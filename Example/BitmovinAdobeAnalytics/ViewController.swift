//
//  ViewController.swift
//  BitmovinAdobeAnalyticsExample
//
//  Copyright (c) 2020 Bitmovin. All rights reserved.
//

import UIKit
import BitmovinPlayer
import BitmovinAdobeAnalytics

class ViewController: UIViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var playerUIView: UIView!
    @IBOutlet weak var adsSwitch: UISwitch!
    @IBOutlet weak var streamUrlTextField: UITextField!
    @IBOutlet weak var uiEventLabel: UILabel!

    var player: Player?
    var playerView: PlayerView?
    var fullScreen: Bool = false

    var adobeAnalytics: AdobeMediaAnalytics?
    var activeAdBreakPosition: Double = 0
    var activeAdPosition: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBitmovinPlayer()

        if let posterUrl = vodSourceConfig.posterSource {
            // Be aware that this will be executed synchronously on the main thread (change to SDWebImage if needed)
            if let data = try? Data(contentsOf: posterUrl) {
                posterImageView.image = UIImage(data: data)
            }
        }
    }

    func setupBitmovinPlayer() {
        // Setup Player
        player = PlayerFactory.create(playerConfig: playerConfig)

        let adobeConfig = AdobeConfiguration()
        adobeConfig.debugLoggingEnabled = true

        do {
            adobeAnalytics = try AdobeMediaAnalytics(player: player!,
                                                    config: adobeConfig,
                                                    delegate: self)
        } catch {
            NSLog("[ Example ] AdobeAnalytics initialization failed with error: \(error)")
        }

        // Setup UI
        playerView = PlayerView(player: player!, frame: playerUIView.bounds)
        playerView?.fullscreenHandler = self

        if let adobeAnalytics = adobeAnalytics {
            adobeAnalytics.playerView = playerView
        }

        playerView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        playerUIView.addSubview(playerView!)

        player?.load(source: SourceFactory.create(from: vodSourceConfig))
    }

    var playerConfig: PlayerConfig {
        let playerConfig = PlayerConfig()
        if adsSwitch.isOn {
            playerConfig.advertisingConfig = adConfig
        }
        return playerConfig
    }

    var vodSourceConfig: SourceConfig {
        var sourceString = "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8"
        if let streamString = streamUrlTextField.text,
           URL(string: streamString) != nil {
            sourceString = streamString
        }

        let sourceConfig = SourceConfig(url: URL(string: sourceString)!, type: .hls)
        sourceConfig.posterSource = URL(string: "https://bitmovin-a.akamaihd.net/content/poster/hd/RedBull.jpg")
        sourceConfig.title = "Art of Motion"
        return sourceConfig
    }

    var adConfig: AdvertisingConfig {
        // swiftlint:disable:next line_length
        let adTagVmap = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&correlator="

        let adSource = AdSource(tag: URL(string: adTagVmap)!, ofType: .ima)

        let vmap = AdItem(adSources: [adSource], atPosition: "pre")

        let adConfig = AdvertisingConfig(schedule: [vmap])

        return adConfig
    }

    // MARK: - actions
    @IBAction func setupPlayer(_ sender: Any) {
        player?.load(source: SourceFactory.create(from: vodSourceConfig))
    }

    @IBAction func destroyPlayer(_ sender: Any) {
        player?.unload()
    }
}

extension ViewController: FullscreenHandler {
    var isFullscreen: Bool {
        return fullScreen
    }

    func onFullscreenRequested() {
        fullScreen = true
        uiEventLabel.text = "enterFullscreen"
    }

    func onFullscreenExitRequested() {
        fullScreen = false
        uiEventLabel.text = "exitFullscreen"
    }
}

extension ViewController: AdobeAnalyticsDataOverrideDelegate {

    func getMediaContextData (_ player: Player) -> NSMutableDictionary? {
        return ["os": "iOS"]
    }

    func getMediaName (_ player: Player, _ source: Source) -> String {
        return source.sourceConfig.title ?? "Test_Media_Name"
    }

    func getMediaId (_ player: Player, _ source: Source) -> String {
        return source.sourceConfig.title ?? "Test_Media_Id"
    }

    func getAdBreakId (_ player: Player, _ event: AdBreakStartedEvent) -> String {
        return event.adBreak.identifier
    }

    func getAdBreakPosition (_ player: Player, _ event: AdBreakStartedEvent) -> Double {
        activeAdPosition = 0
        activeAdBreakPosition += 1
        return activeAdBreakPosition
    }

    func getAdName (_ player: Player, _ event: AdStartedEvent) -> String {
        return event.ad.identifier ?? "default_Ad_Id"
    }

    func getAdId (_ player: Player, _ event: AdStartedEvent) -> String {
        return event.ad.identifier ?? "default_Ad_Id"
    }

    func getAdPosition (_ player: Player, _ event: AdStartedEvent) -> Double {
        activeAdPosition += 1
        return activeAdPosition
    }
}
