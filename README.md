# Eurofurence for iOS

Master | 3.1.0
------ | ------
[![Build Status](https://app.bitrise.io/app/5b6b557ef37c13bc/status.svg?token=0LTkUzpKBZi3QWMWVyXTPA&branch=master)](https://app.bitrise.io/app/5b6b557ef37c13bc) | [![Build Status](https://app.bitrise.io/app/5b6b557ef37c13bc/status.svg?token=0LTkUzpKBZi3QWMWVyXTPA&branch=release/3.1.0)](https://app.bitrise.io/app/5b6b557ef37c13bc)

Source code for the Eurofurence app for iOS.

## External Services

This app uses the [Eurofurence API](https://app.eurofurence.org/swagger/v2/ui/) for its backing model. We also use [Firebase](https://firebase.google.com) for crash reporting and push notifications.

## Building From Source

To build the app, you'll need the latest versions of:

- Xcode 10
- Cocoapods

Once you clone the repository, open the workspace (not the project!). You'll find a few schemes knocking around:

- **Eurofurence** - Runs the iOS app and runs tests against the app and model
- **Application** - Also runs the iOS app, but only runs the tests against the app
- **Screenshots** - Used for generating screenshots using Fastlane
- **EurofurenceModel** - Houses the services and repositories used by the app
- **EurofurenceModelAdapterTests** - Contains tests for adapters from the model into system APIs (e.g. Core Data)

## Contributing

Any bugs or prospective chunks of work should be [raised as issues](https://github.com/eurofurence/ef-app_ios/issues/new), tiny bits of work included to drive discussions. Help us help you!
