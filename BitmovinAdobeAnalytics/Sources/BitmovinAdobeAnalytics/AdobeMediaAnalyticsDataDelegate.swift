//
//  AdobeConfiguration.swift
//  BitmovinAdobeAnalytics
//
//  Created by Bitmovin on 14.08.20.
//  Copyright (c) 2020 Bitmovin. All rights reserved.
//

import Foundation
import BitmovinPlayer

public protocol AdobeAnalyticsDataOverrideDelegate: AnyObject {

    func getMediaContextData (_ player: BitmovinPlayer) -> NSMutableDictionary?

    func getMediaName (_ player: BitmovinPlayer, _ source: SourceItem) -> String

    func getMediaId (_ player: BitmovinPlayer, _ source: SourceItem) -> String

    func getAdBreakId (_ player: BitmovinPlayer, _ event: AdBreakStartedEvent) -> String

    func getAdBreakPosition (_ player: BitmovinPlayer, _ event: AdBreakStartedEvent) -> Double

    func getAdName (_ player: BitmovinPlayer, _ event: AdStartedEvent) -> String

    func getAdId (_ player: BitmovinPlayer, _ event: AdStartedEvent) -> String

    func getAdPosition (_ player: BitmovinPlayer, _ event: AdStartedEvent) -> Double
    
}

