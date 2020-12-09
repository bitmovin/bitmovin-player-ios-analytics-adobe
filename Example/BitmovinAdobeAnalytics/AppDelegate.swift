//
//  AppDelegate.swift
//  BitmovinAdobeAnalyticsExample
//
//  Copyright (c) 2020 Bitmovin. All rights reserved.
//

import UIKit

import ACPCore
import ACPAnalytics
import ACPMedia

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // setup Adobe analytics
        ACPCore.setLogLevel(.debug)
        ACPCore.configure(withAppId: "YOUR-APP-ID")

        ACPMedia.registerExtension()
        ACPAnalytics.registerExtension()
        ACPIdentity.registerExtension()

        ACPCore.start {

        }
        return true
    }
}
