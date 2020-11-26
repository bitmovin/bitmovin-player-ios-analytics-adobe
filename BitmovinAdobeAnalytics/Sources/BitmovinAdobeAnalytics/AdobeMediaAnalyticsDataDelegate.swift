//
//  AdobeMediaAnalyticsDataDelegate.swift
//  BitmovinAdobeAnalytics
//
//  Copyright (c) 2020 Bitmovin. All rights reserved.
//

import Foundation
import BitmovinPlayer

public protocol AdobeAnalyticsDataOverrideDelegate: AnyObject {

    func getMediaContextData (_ player: Player) -> NSMutableDictionary?

    func getMediaName (_ player: Player, _ source: SourceItem) -> String

    func getMediaId (_ player: Player, _ source: SourceItem) -> String

    func getAdBreakId (_ player: Player, _ event: AdBreakStartedEvent) -> String

    func getAdBreakPosition (_ player: Player, _ event: AdBreakStartedEvent) -> Double

    func getAdName (_ player: Player, _ event: AdStartedEvent) -> String

    func getAdId (_ player: Player, _ event: AdStartedEvent) -> String

    func getAdPosition (_ player: Player, _ event: AdStartedEvent) -> Double
    
}

