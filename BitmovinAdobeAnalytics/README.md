# Bitmovin Player Adobe Analytics Integration
This is an open-source project to enable the use of a third-party component (Abode Video Heartbeat) with the Bitmovin Player iOS SDK.

## Maintenance and Update
This project is not part of a regular maintenance or update schedule. For any update requests, please take a look at the guidance further below.

## Contributions to this project
As an open-source project, we are pleased to accept any and all changes, updates and fixes from the community wishing to use this project. Please see [CONTRIBUTING.md](CONTRIBUTING.md) for more details on how to contribute.

## Reporting player bugs
If you come across a bug related to the player, please raise this through your support ticketing system.

## Need more help?
Should you want some help updating this project (update, modify, fix or otherwise) and cant contribute for any reason, please raise your request to your bitmovin account team, who can discuss your request.

## Support and SLA Disclaimer
As an open-source project and not a core product offering, any request, issue or query related to this project is excluded from any SLA and Support terms that a customer might have with either Bitmovin or another third-party service provider or Company contributing to this project. Any and all updates are purely at the contributor's discretion.

Thank you for your contributions!

## Requirements
-----------------
1. Adobe Experience Cloud account
2. Bitmovin account
3. Adobe Experience Platform for mobile AEP SDKs is configured and "launch-app-id" setup as provided in the [Adobe documentation](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/mobile-core/configuration)

## Getting started
------------------

### Installation & Configuration

1. `BitmovinAdobeAnalytics` is available through [CocoaPods](https://cocoapods.org). We depend on cocoapods version >= 1.9.0

- To install it, simply add it as a dependency to your project. Add the following pod to your Podfile:

```
pod 'BitmovinAdobeAnalytics', git: 'https://github.com/bitmovin/bitmovin-player-ios-analytics-adobe.git', tag: '2.0.0'
```

2. Add Adobe Media Analytics to your application. Please refer to [Adobe documentation](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/adobe-media-analytics#add-media-analytics-to-your-app)

- To add the Media library and its dependencies to your project, add the following pods to your Podfile:

```
pod 'ACPCore', '~> 2.0'
pod 'ACPAnalytics', '~> 2.0'
pod 'ACPMedia', '~> 2.0'
```

3. Then, in your command line run:

```
pod install
```

4. In Xcode project, import Media extension.

```swift
import ACPMedia;
```

3. Register Media with mobile core. Please refer to [Adobe documentation](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/adobe-media-analytics#register-media-with-mobile-core)

- In your app's `application:didFinishLaunchingWithOptions`, register Media with Mobile Core:

```swift
import ACPCore
import ACPAnalytics
import ACPIdentity
import ACPMedia

func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    ACPCore.setLogLevel(.debug)
    ACPCore.configure(withAppId: "your-launch-app-id")

    ACPAnalytics.registerExtension()
    ACPIdentity.registerExtension()
    ACPMedia.registerExtension()

    ACPCore.start {

    }

    return true;
}
```

`your-launch-app-id` : ApplicationId setup following steps [here](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/mobile-core/configuration)

### Compatibility
Versions 2.x.x of this Adobe analytics integration is comaptible with `BitmovinPlayer` version `>= 3.0.0`.
Versions 1.x.x of this Adobe analytics integration is compatible with `BitmovinPlayer` version `< 3.0.0`. Please note that the Bitmovin Player iOS SDK v2 is not supported anymore.

## Usage
----------------
The `BitmovinAdobeAnalytics` module provides information for each video uniquely. The module exposes the following objects:

1. `AdobeMediaAnalytics`: This object is the entry point to be used by the application to start tracking Adobe Media Analytics. The following example shows how to setup the BitmovinAdobeAnalytics.

```swift
let adobeConfig = AdobeConfiguration()
adobeConfig.debugLoggingEnabled = true
do {
    adobeAnalytics = try AdobeMediaAnalytics(player: player!,
                                            config: adobeConfig,
                                            delegate: self)
} catch {
    NSLog("[ Example ] AdobeAnalytics initialization failed with error: \(error)")
}
```
2. `AdobeConfiguration`: This object is used to configure the Adobe analytics module. This can be used to configure if debugging should be enabled or not for the module.

3. `AdobeAnalyticsDataOverrideDelegate`: This defines a protocol with menthods for calculating metadata to be sent with Adobe analytics events. A default implentation is provide by the module but it SHOULD be overridden by application to provide custom override methods for the values of fields of Adobe Media Analytics event data. A list of methods in the protocol and default values is provided below.

### Media

| Method (With Signature)                                                  |       Default Value       | Description|
| :-----------------------------------------------------------------------:|:-------------------------:|-----------:|
| func getMediaName (_ player: Player, _ source: SourceItem) -> String     | 	"default_Media_Name"   | Should return the name of media being played|
| func getMediaId (_ player: Player, _ source: SourceItem) -> String       | 	"default_Media_ID"     | Should return an identifier of media being played|
| func getMediaContextData (_ player: Player) -> NSMutableDictionary?      | 	nill                   | Should return the custom metadata for the playback session|

### Ads

| Method (With Signature)                                                             | Default Value                     | Description |
| -----------------------------------------------------------------------------------:|:---------------------------------:|:-----------:|
| func getAdBreakId (_ player: Player, _ event: AdBreakStartedEvent) -> String        | generated AdBreakID               | Should return the ID of the current Ad Break|
| func getAdBreakPosition (_ player: Player, _ event: AdBreakStartedEvent) -> Double  | index of AdBreak                  | Should return index of current adBreak among all Ad Breaks|
| func getAdName (_ player: Player, _ event: AdStartedEvent) -> String                | generated AdID or "default_Ad_Id" | Should return name of the current Ad|
| func getAdId (_ player: Player, _ event: AdStartedEvent) -> String                  | generated AdID or "default_Ad_Id" | Should return ID of the current Ad|
| func getAdPosition (_ player: Player, _ event: AdStartedEvent) -> Double            | index of Ad in AdBreak            | Should return index of current Ad in Ad Break|


The specification of Adobe Media Analytics event data can be found [here](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/adobe-media-analytics/media-api-reference)
