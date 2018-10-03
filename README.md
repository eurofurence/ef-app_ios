# ef-app_ios

[![Build Status](https://travis-ci.org/eurofurence/ef-app_ios.svg?branch=master)](https://travis-ci.org/eurofurence/ef-app_ios)

Source code for the Eurofurence app for iOS.

## External Services

This app uses the [Eurofurence API](https://app.eurofurence.org/swagger/v2/ui/) for its backing model. We also use [Firebase](https://firebase.google.com) for crash reporting and push notifications.

## Building From Source

To build the app, you'll need:

- Xcode 10
- Cocoapods 1.5.3

Once you have the tools, to build the app from source you'll need to:

- Clone this repository (duh)
- Run `pod install` in the root of the directory to bring down the [Swiftlint](https://github.com/realm/SwiftLint) pod (providing automatic linting as you build)
- Open `Eurofurence.xcworkspace`, activate the Eurofurence scheme if it isn't already
- Build and run the scheme on the simulator of your choice
- Sit back with a cold one 🍻

## Contributing

Any bugs or prospective chunks of work should be [raised as issues](https://github.com/eurofurence/ef-app_ios/issues/new), tiny bits of work included to drive discussions. Help us help you!
