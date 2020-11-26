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
        ACPCore.configure(withAppId: "2e662f4d7a02/f7314e644f8f/launch-98a1c3e547bf-development")

        ACPMedia.registerExtension()
        ACPAnalytics.registerExtension()
        ACPIdentity.registerExtension()

        ACPCore.start {

        }
        return true
    }
}
