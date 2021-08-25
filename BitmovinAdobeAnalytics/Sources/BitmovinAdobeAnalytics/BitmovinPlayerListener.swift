//
//  BitmovinPlayerListener.swift
//  BitmovinAdobeAnalytics
//
//  Copyright (c) 2020 Bitmovin. All rights reserved.
//

import Foundation
import BitmovinPlayer

class BitmovinPlayerListener: NSObject {
    let player: Player
    weak var delegate: BitmovinPlayerListenerDelegate?

    init(player: Player) {
        self.player = player
        super.init()
        self.player.add(listener: self)
    }

    deinit {
        player.remove(listener: self)
    }
}

extension BitmovinPlayerListener: PlayerListener {
    func onEvent(_ event: Event, player: Player) {
        delegate?.onEvent(event)
    }

    func onSourceUnloaded(_ event: SourceUnloadedEvent, player: Player) {
        // The default SDK error handling is that it triggers the onSourceUnloaded before the onError event.
        // To track errors to Adobe we need to delay the onSourceUnloaded to ensure the onError event is called first.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.delegate?.onSourceUnloaded()
        }
    }

    func onTimeChanged(_ event: TimeChangedEvent, player: Player) {
        delegate?.onTimeChanged(event)
    }

    func onPlayerError(_ event: PlayerErrorEvent, player: Player) {
        delegate?.onPlayerError(event)
    }
    
    func onSourceError(_ event: SourceErrorEvent, player: Player) {
        delegate?.onSourceError(event)
    }

    func onMuted(_ event: MutedEvent, player: Player) {
        delegate?.onMuted(event)
    }

    func onUnmuted(_ event: UnmutedEvent, player: Player) {
        delegate?.onUnmuted(event)
    }

    // MARK: - Playback state events
    func onPlay(_ event: PlayEvent, player: Player) {
        delegate?.onPlay()
    }

    func onPlaying(_ event: PlayingEvent, player: Player) {
        delegate?.onPlaying()
    }

    func onPaused(_ event: PausedEvent, player: Player) {
        delegate?.onPaused()
    }

    func onPlaybackFinished(_ event: PlaybackFinishedEvent, player: Player) {
        delegate?.onPlaybackFinished()
    }

    func onStallStarted(_ event: StallStartedEvent, player: Player) {
        delegate?.onStallStarted()
    }

    func onStallEnded(_ event: StallEndedEvent, player: Player) {
        delegate?.onStallEnded()
    }

    // MARK: - Seek / Timeshift events
    func onSeek(_ event: SeekEvent, player: Player) {
        delegate?.onSeek(event)
    }

    func onSeeked(_ event: SeekedEvent, player: Player) {
        delegate?.onSeeked()
    }

    func onTimeShift(_ event: TimeShiftEvent, player: Player) {
        delegate?.onTimeShift(event)
    }

    func onTimeShifted(_ event: TimeShiftedEvent, player: Player) {
        delegate?.onTimeShifted()
    }
    
    func onVideoDownloadQualityChanged(_ event: VideoDownloadQualityChangedEvent, player: Player) {
        delegate?.onVideoQualityChanged(event)
    }

    #if !os(tvOS)
    // MARK: - Ad events
    func onAdBreakStarted(_ event: AdBreakStartedEvent, player: Player) {
        delegate?.onAdBreakStarted(event)
    }
    
    func onAdBreakFinished(_ event: AdBreakFinishedEvent, player: Player) {
        delegate?.onAdBreakFinished(event)
    }
    
    func onAdStarted(_ event: AdStartedEvent, player: Player) {
        delegate?.onAdStarted(event)
    }

    func onAdFinished(_ event: AdFinishedEvent, player: Player) {
        delegate?.onAdFinished(event)
    }

    func onAdSkipped(_ event: AdSkippedEvent, player: Player) {
        delegate?.onAdSkipped(event)
    }

    func onAdError(_ event: AdErrorEvent, player: Player) {
        delegate?.onAdError(event)
    }
    #endif

    func onDestroy(_ event: DestroyEvent, player: Player) {
        delegate?.onDestroy()
    }
}
