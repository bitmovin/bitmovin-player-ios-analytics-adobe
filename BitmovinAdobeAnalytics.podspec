Pod::Spec.new do |s|
  s.name             = 'BitmovinAdobeAnalytics'
  s.version          = '2.0.0'
  s.summary          = 'Adobe Analytics Integration for the Bitmovin Player iOS SDK'

  s.description      = <<-DESC
Adobe Analytics Integration for the Bitmovin Player iOS SDK
                       DESC

  s.homepage         = 'https://github.com/bitmovin/bitmovin-player-ios-analytics-adobe'
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { 'Bitmovin' => 'lucky.goyal@bitmovin.com' }
  s.source           = { git: 'https://github.com/bitmovin/bitmovin-player-ios-analytics-adobe.git', tag: s.version.to_s }
  #s.source           = { git: '' }
  s.ios.deployment_target = '12.0'
  s.tvos.deployment_target = '12.0'

  s.source_files = 'BitmovinAdobeAnalytics/Sources/**/*.swift'
  s.resources = 'BitmovinAdobeAnalytics/Assets/*'
  s.swift_version = '5.2'
  s.cocoapods_version = '>= 1.9.0'

  s.ios.dependency 'BitmovinPlayer', '~> 3.0'
  s.ios.dependency 'ACPCore', '~> 2.0'
  s.ios.dependency 'ACPAnalytics', '~> 2.0'
  s.ios.dependency 'ACPMedia', '~> 2.0'
  s.tvos.dependency 'BitmovinPlayer', '~> 3.0'
  s.tvos.dependency 'ACPCore', '~> 2.0'
  s.tvos.dependency 'ACPAnalytics', '~> 2.0'
  s.tvos.dependency 'ACPMedia', '~> 2.0'

  s.static_framework = true
end
