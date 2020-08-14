//
//  AdobeConfiguration.swift
//  BitmovinAdobeAnalytics
//
//  Created by Bitmovin on 14.08.20.
//  Copyright (c) 2020 Bitmovin. All rights reserved.
//

import Foundation

final class Logger: NSObject {
    var loggingEnabled: Bool = false

    init(loggingEnabled: Bool) {
        self.loggingEnabled = loggingEnabled
    }

    func debugLog(message: String) {
        if loggingEnabled {
            NSLog("[ Bitmovin Adobe Analytics ] %@", message)
        }
    }
}
