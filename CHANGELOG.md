# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Changed
- Updated `BitmovinPlayer` to `3.41.0`
- Raised minimum deployment target to iOS/tvOS 14

## 2.0.0 - 2021-09-01
### Added
- This is first version using Bitmovin Player iOS V3 SDK. This is not backward compatible with V2 player SDK.

### Known Issues
- Playlist API available in V3 player SDK is not supported.

## 1.2.0 - 2020-03-30
### Fixed
- Fixed streamType to be set correctly as Live or VOD

## 1.1.1 - 2020-03-18
### Fixed
- Fixed crash issue if `ACPMedia.createTracker()` returns `nil` and AdobeMediaAnalytics cannot be instantiated

## 1.0.0 - 2020-12-10
### Added
- Initial implementation
