//
//  AdobeConfiguration.swift
//  BitmovinAdobeAnalytics
//
//  Created by Bitmovin on 14.08.20.
//  Copyright (c) 2020 Bitmovin. All rights reserved.
//

import UIKit
import BitmovinPlayer
import BitmovinAdobeAnalytics

class ViewController: UIViewController {

    var player: BitmovinPlayer?
    var playerView: BMPBitmovinPlayerView?
    var fullScreen: Bool = false

    var adobeAnalytics: AdobeMediaAnalytics?
    var activeAdBreakPosition: Double = 0
    var activeAdPosition: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBitmovinPlayer()
    }

    func setupBitmovinPlayer() {
        // Setup Player
        player = BitmovinPlayer()

        let adobeConfig = AdobeConfiguration()
        adobeConfig.debugLoggingEnabled = true

        do {
            adobeAnalytics = try AdobeMediaAnalytics(player: player!,
                                                    config: adobeConfig,
                                                    delegate: self)
        } catch {
            NSLog("[ Example ] AdobeAnalytics initialization failed with error: \(error)")
        }

        player?.setup(configuration: playerConfiguration)

        // Setup UI
        playerView = BMPBitmovinPlayerView(player: player!, frame: .zero)
        playerView?.frame = view.bounds

        if let adobeAnalytics = adobeAnalytics {
            adobeAnalytics.playerView = playerView
        }

        playerView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(playerView!)
        view.bringSubviewToFront(playerView!)
    }

    var playerConfiguration: PlayerConfiguration {
        let playerConfiguration = PlayerConfiguration()
        playerConfiguration.sourceItem = sourceItem

        return playerConfiguration
    }

    var sourceItem: SourceItem? {
        let sourceString = "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8"
        guard let url = URL(string: sourceString),
            let sourceItem = SourceItem(url: url) else {
                return nil
        }
        sourceItem.posterSource = URL(string: "https://bitmovin-a.akamaihd.net/content/poster/hd/RedBull.jpg")
        sourceItem.itemTitle = "Art of Motion"
        return sourceItem
    }
}
extension ViewController: AdobeAnalyticsDataOverrideDelegate {

    func getMediaContextData (_ player: BitmovinPlayer) -> NSMutableDictionary? {
        return ["os": "iOS/tvOS"]
    }

    func getMediaName (_ player: BitmovinPlayer, _ source: SourceItem) -> String {
        return source.itemTitle ?? "Test_Media_Name"
    }

    func getMediaId (_ player: BitmovinPlayer, _ source: SourceItem) -> String {
        return source.itemTitle ?? "Test_Media_Id"
    }

    func getAdBreakId (_ player: BitmovinPlayer, _ event: AdBreakStartedEvent) -> String {
        return event.adBreak.identifier
    }

    func getAdBreakPosition (_ player: BitmovinPlayer, _ event: AdBreakStartedEvent) -> Double {
        activeAdPosition = 0
        activeAdBreakPosition += 1
        return activeAdBreakPosition
    }

    func getAdName (_ player: BitmovinPlayer, _ event: AdStartedEvent) -> String {
        return event.ad.identifier ?? "default_Ad_Id"
    }

    func getAdId (_ player: BitmovinPlayer, _ event: AdStartedEvent) -> String {
        return event.ad.identifier ?? "default_Ad_Id"
    }

    func getAdPosition (_ player: BitmovinPlayer, _ event: AdStartedEvent) -> Double {
        activeAdPosition += 1
        return activeAdPosition
    }
}
