# Eurofurence for iOS

Master | 3.1.4
------ | ------
[![Build Status](https://app.bitrise.io/app/5b6b557ef37c13bc/status.svg?token=0LTkUzpKBZi3QWMWVyXTPA&branch=master)](https://app.bitrise.io/app/5b6b557ef37c13bc) | [![Build Status](https://app.bitrise.io/app/5b6b557ef37c13bc/status.svg?token=0LTkUzpKBZi3QWMWVyXTPA&branch=release/3.1.4)](https://app.bitrise.io/app/5b6b557ef37c13bc)

Source code for the Eurofurence app for iOS.

## External Services

This app uses the [Eurofurence API](https://app.eurofurence.org/swagger/v2/ui/) for its backing model. We also use [Firebase](https://firebase.google.com) for crash reporting and push notifications.

## Building From Source

To build the app, you'll need the latest version of Xcode 12. Once you clone the repository, open the workspace (not the project!). You'll find a few schemes knocking around:

- **Eurofurence** - Houses the iOS app, Intent definitions and test plans
- **EurofurenceModel** - Houses the services and repositories used by the app

## Updating Dependencies

The Eurofurence app commits its dependencies to source (as seen under the _Pods_ directory). This guarantees consistency between dev environments as there's no change of differing versions of the Cocoapods gem configuring the project differently machines - specifically useful for CI.

When required, a *pod install* or *pod update* should be done using Bundler to keep everyone on the same version of Cocoapods, i.e. instead of executing **pod (install|update)** please us **bundle exec pod (install|update)**.

## Contributing

Any bugs or prospective chunks of work should be [raised as issues](https://github.com/eurofurence/ef-app_ios/issues/new), tiny bits of work included to drive discussions. Help us help you!
