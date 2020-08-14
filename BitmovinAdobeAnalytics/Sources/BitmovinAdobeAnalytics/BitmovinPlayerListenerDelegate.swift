//
//  AdobeConfiguration.swift
//  BitmovinAdobeAnalytics
//
//  Created by Bitmovin on 14.08.20.
//  Copyright (c) 2020 Bitmovin. All rights reserved.
//

import Foundation
import BitmovinPlayer

protocol BitmovinPlayerListenerDelegate: AnyObject {
    func onEvent(_ event: PlayerEvent)
    func onSourceUnloaded()
    func onTimeChanged(_ event: TimeChangedEvent)
    func onError(_ event: ErrorEvent)

    func onMuted(_ event: MutedEvent)
    func onUnmuted(_ event: UnmutedEvent)
    func onVideoQualityChanged(_ event: VideoDownloadQualityChangedEvent)

    // MARK: - Playback state events
    func onPlay()
    func onPlaying()
    func onPaused()
    func onPlaybackFinished()
    func onStallStarted()
    func onStallEnded()

    // MARK: - Seek / Timeshift events
    func onSeek(_ event: SeekEvent)
    func onSeeked()
    func onTimeShift(_ event: TimeShiftEvent)
    func onTimeShifted()

    #if !os(tvOS)
    // MARK: - Ad events
    func onAdBreakStarted(_ event: AdBreakStartedEvent)
    func onAdBreakFinished(_ event: AdBreakFinishedEvent)
    func onAdStarted(_ event: AdStartedEvent)
    func onAdFinished(_ event: AdFinishedEvent)
    func onAdSkipped(_ event: AdSkippedEvent)
    func onAdError(_ event: AdErrorEvent)
    #endif

    func onDestroy()
}
