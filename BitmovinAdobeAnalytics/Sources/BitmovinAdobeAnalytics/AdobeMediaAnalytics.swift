//
//  AdobeMediaAnalytics.swift
//  BitmovinAdobeAnalytics
//
//  Copyright (c) 2020 Bitmovin. All rights reserved.
//

import ACPMedia
import BitmovinPlayer

public final class AdobeMediaAnalytics: NSObject {
    // MARK: - Bitmovin Player attributes
    let player: Player

    // MARK: - Adobe analytics related attributes
    let mediaTracker: ACPMediaTracker
    let config: AdobeConfiguration
    var isSessionActive: Bool = false
    weak var dataOverrideDelegate: AdobeAnalyticsDataOverrideDelegate?

    // The BitmovinPlayerListener is used to prevent listener methods to be public and therefore
    // preventing calling from outside.
    var listener: BitmovinPlayerListener?
    
    var activeAdBreakPosition: Double = 0
    var isPaused = false

    // MARK: - Helper
    let logger: Logger

    // MARK: - Public Attributes
    /**
     Set the BMPBitmovinPlayerView to enable view triggered events like fullscreen state changes
     */
    public var playerView: PlayerView? {
        didSet {
            playerView?.remove(listener: self)
            playerView?.add(listener: self)
        }
    }

    // MARK: - initializer
    /**
     Initialize a new Bitmovin Adobe Analytics object to track metrics from BitmovinPlayer

     **!! AdobeMediaAnalytics must be instantiated before calling player.setup() !!**

     - Parameters:
        - player: BitmovinPlayer instance to track
        - config: AdobeConfiguration object (see AdobeConfiguration for more information)
     */
    public init?(player: Player,
                 config: AdobeConfiguration = AdobeConfiguration(),
                 delegate: AdobeAnalyticsDataOverrideDelegate?) throws {
        if let mediaTracker = ACPMedia.createTracker() {
            self.mediaTracker = mediaTracker
        } else {
            return nil;
        }

        self.player = player
        self.config = config
        self.logger = Logger(loggingEnabled: config.debugLoggingEnabled)
        self.dataOverrideDelegate = delegate
        self.listener = BitmovinPlayerListener(player: player)
        
        super.init()
        
        self.listener?.delegate = self
        if (self.dataOverrideDelegate == nil) {
            self.dataOverrideDelegate = self
        }
    }

    deinit {
        if isSessionActive {
            mediaTracker.trackSessionEnd();
        }
        internalEndSession()
    }

    // MARK: - session handling

    private func internalInitializeSession() {
        
        if isSessionActive {
            logger.debugLog(message: "Trying to initailize new session and existing session not finished")
            return
        }
        
        let mediaMetadata = dataOverrideDelegate?.getMediaContextData(player)
        let mediaObject = ACPMedia.createMediaObject(withName: "video-name",
                                                     mediaId: "video-id",
                                                     length: player.duration,
                                                     streamType: player.isLive ? ACPMediaStreamTypeLive:ACPMediaStreamTypeVod,
                                                     mediaType:ACPMediaType.video)
        
        mediaTracker.trackSessionStart(mediaObject, data:mediaMetadata as? [AnyHashable : Any]);
        isSessionActive = true

        logger.debugLog(message: "Session started")
    }

    private func internalEndSession() {
        if !isSessionActive {
            return
        }
        
        isSessionActive = false

        logger.debugLog(message: "Session ended")
    }
}

// MARK: - PlayerListener
extension AdobeMediaAnalytics: BitmovinPlayerListenerDelegate {
    
    func onEvent(_ event: Event) {
        logger.debugLog(message: "[ Player Event ] \(event.name)")
    }

    func onSourceUnloaded() {
        mediaTracker.trackSessionEnd();
        internalEndSession()
    }

    func onTimeChanged(_ event: TimeChangedEvent) {
        mediaTracker.updateCurrentPlayhead(event.currentTime)
    }

    func onPlayerError(_ event: PlayerErrorEvent) {
        if !isSessionActive {
            internalInitializeSession()
        }

        let message = "\(event.code) \(event.message)"
        mediaTracker.trackError(message)
    }
    
    func onSourceError(_ event: SourceErrorEvent) {
        if !isSessionActive {
            internalInitializeSession()
        }

        let message = "\(event.code) \(event.message)"
        mediaTracker.trackError(message)
    }

    func onMuted(_ event: MutedEvent) {
        let stateObject = ACPMedia.createStateObject(withName: "mute")
        mediaTracker.trackEvent(ACPMediaEvent.stateStart, info: stateObject, data: nil)
    }

    func onUnmuted(_ event: UnmutedEvent) {
        let stateObject = ACPMedia.createStateObject(withName: "mute")
        mediaTracker.trackEvent(ACPMediaEvent.stateEnd, info: stateObject, data: nil)
    }

    func onVideoQualityChanged(_ event: VideoDownloadQualityChangedEvent) {
        // Update metadata
        if !isSessionActive {
            return
        }

        // If the new bitrate value is available provide it to the tracker.
        let bitrate = (event.videoQualityNew != nil) ? (event.videoQualityNew?.bitrate ?? 0) : (player.videoQuality?.bitrate ?? 0)
        let framerate = player.currentVideoFrameRate
        let qoeObject = ACPMedia.createQoEObject(withBitrate: Double(bitrate), startupTime: 0, fps: Double(framerate), droppedFrames: 0)
        mediaTracker.updateQoEObject(qoeObject)

        // Bitrate change
        mediaTracker.trackEvent(ACPMediaEvent.bitrateChange, info: nil, data: nil)

    }
    
    // MARK: - Playback state events
    func onPlay() {
        if !isSessionActive {
            internalInitializeSession()
        }
    }

    func onPlaying() {
        mediaTracker.trackPlay()
        isPaused = false
    }

    func onPaused() {
        mediaTracker.trackPause()
        isPaused = true
    }

    func onPlaybackFinished() {
        mediaTracker.trackComplete()
        mediaTracker.trackSessionEnd()
        internalEndSession()
    }

    func onStallStarted() {
        mediaTracker.trackEvent(ACPMediaEvent.bufferStart, info: nil, data: nil)
    }

    func onStallEnded() {
        mediaTracker.trackEvent(ACPMediaEvent.bufferComplete, info: nil, data: nil)
    }

    // MARK: - Seek / Timeshift events
    func onSeek(_ event: SeekEvent) {
        if !isSessionActive {
            // Handle the case that the User seeks on the UI before play was triggered.
            // This also handles startTime feature. The same applies for onTimeShift.
            return
        }
        mediaTracker.trackEvent(ACPMediaEvent.seekStart, info: nil, data: nil)
    }

    func onSeeked() {
        if !isSessionActive {
            // See comment in onSeek
            return
        }

        mediaTracker.trackEvent(ACPMediaEvent.seekComplete, info: nil, data: nil)
    }

    func onTimeShift(_ event: TimeShiftEvent) {
        if !isSessionActive {
            // See comment in onSeek
            return
        }

        mediaTracker.trackEvent(ACPMediaEvent.seekStart, info: nil, data: nil)
    }

    func onTimeShifted() {
        if !isSessionActive {
            // See comment in onSeek
            return
        }

        mediaTracker.trackEvent(ACPMediaEvent.seekComplete, info: nil, data: nil)
    }

    #if !os(tvOS)
    // MARK: - Ad events
    func onAdBreakStarted(_ event: AdBreakStartedEvent) {
        // AdBreakStart
        let adBreakName = dataOverrideDelegate?.getAdBreakId(player, event)
        let adBreakPosition = dataOverrideDelegate?.getAdBreakPosition(player, event)
        let adBreakScheduleTime = event.adBreak.scheduleTime
        let adBreakObject = ACPMedia.createAdBreakObject(withName: adBreakName!, position: adBreakPosition!, startTime: adBreakScheduleTime)
        mediaTracker.trackEvent(ACPMediaEvent.adBreakStart, info: adBreakObject, data: nil)
    }
    
    func onAdBreakFinished(_ event: AdBreakFinishedEvent) {
        // AdBreakComplete
        mediaTracker.trackEvent(ACPMediaEvent.adBreakComplete, info: nil, data: nil)
    }
    
    func onAdStarted(_ event: AdStartedEvent) {
        // AdStart
        let adName = dataOverrideDelegate?.getAdName(player, event)
        let adId = dataOverrideDelegate?.getAdId(player, event)
        let adPosition = dataOverrideDelegate?.getAdPosition(player, event)
        let adDuration = event.duration
        let adObject = ACPMedia.createAdObject(withName: adName!, adId: adId!, position: adPosition!, length: adDuration)

        // Bitmovin player sends Pause event when switching from main content to Ad
        // start tracking Ad play when Ad starts. Do not check `player.isPaused` as
        // that reflects state for main content playback
        if (isPaused) {
            mediaTracker.trackPlay()
            isPaused = false
        }

        mediaTracker.trackEvent(ACPMediaEvent.adStart, info: adObject, data: nil)
    }

    func onAdFinished(_ event: AdFinishedEvent) {
        // AdComplete
        mediaTracker.trackEvent(ACPMediaEvent.adComplete, info: nil, data: nil)
    }

    func onAdSkipped(_ event: AdSkippedEvent) {
        // AdSkip
        mediaTracker.trackEvent(ACPMediaEvent.adSkip, info: nil, data: nil)
    }

    func onAdError(_ event: AdErrorEvent) {

    }
    #endif

    func onDestroy() {
        mediaTracker.trackSessionEnd();
        internalEndSession()
    }
}

// MARK: - UserInterfaceListener
extension AdobeMediaAnalytics: UserInterfaceListener {
    public func onFullscreenEnter(_ event: FullscreenEnterEvent) {
        let stateObject = ACPMedia.createStateObject(withName: "fullscreen")
          mediaTracker.trackEvent(ACPMediaEvent.stateStart, info: stateObject, data: nil)
    }

    public func onFullscreenExit(_ event: FullscreenExitEvent) {
        let stateObject = ACPMedia.createStateObject(withName: "fullscreen")
        mediaTracker.trackEvent(ACPMediaEvent.stateEnd, info: stateObject, data: nil)
    }
}

extension AdobeMediaAnalytics: AdobeAnalyticsDataOverrideDelegate {
    
    public func getMediaContextData (_ player: Player) -> NSMutableDictionary? {
        return nil
    }

    public func getMediaName (_ player: Player, _ source: Source) -> String {
        return "default_Media_Name"
    }

    public func getMediaId (_ player: Player, _ source: Source) -> String {
        return "default_Media_ID"
    }
    
    public func getAdBreakId (_ player: Player, _ event: AdBreakStartedEvent) -> String {
        return event.adBreak.identifier
    }

    public func getAdBreakPosition (_ player: Player, _ event: AdBreakStartedEvent) -> Double {
        activeAdBreakPosition += 1
        return activeAdBreakPosition;
    }

    public func getAdName (_ player: Player, _ event: AdStartedEvent) -> String {
        return event.ad.identifier ?? "default_Ad_Id"
    }

    public func getAdId (_ player: Player, _ event: AdStartedEvent) -> String {
        return event.ad.identifier ?? "default_Ad_Id"
    }

    public func getAdPosition (_ player: Player, _ event: AdStartedEvent) -> Double {
        return Double(event.indexInQueue)
    }
}
