# Eurofurence for iOS

[Download the app on the App Store!](https://apps.apple.com/gb/app/eurofurence-convention/id1112547322)

[![Build Status](https://app.bitrise.io/app/5b6b557ef37c13bc/status.svg?token=0LTkUzpKBZi3QWMWVyXTPA&branch=release/4.0.0)](https://app.bitrise.io/app/5b6b557ef37c13bc)

Source code for the Eurofurence app for iOS.

## Dependencies

The application uses several service and code level dependencies to function.

### External Services

This app uses the [Eurofurence API](https://app.eurofurence.org/swagger/v2/ui/) for its backing model. We also use [Firebase](https://firebase.google.com) for crash reporting and push notifications.

### 3rd Party Dependencies

All our dependencies are installed using the [Swift Package Manager](https://swift.org/package-manager/).

- [Down](https://github.com/johnxnguyen/Down) - Markdown parsing and formatting
- [Firebase](https://github.com/firebase/firebase-ios-sdk) - Crash reporting, push messaging and remote configuration

## Building From Source

To build the app, you'll need the latest version of Xcode 13. Once you clone the repository, open the workspace (not the project!). Give Xcode a few minutes to resolve the dependencies.

To build and run the app, select the __Eurofurence__ project file, activate the __Eurofurence__ scheme, and hit `Product > Run` (or `⌘ + R`). Other schemes of interest include:

- __EurofurenceKit__ - the model used by the application.
- __EurofurenceIntentDefinitions__ - all `INIntent` definitions live here for sharing betweeen targets
- __EventsWidgetExtension__ - Springboard extension for events

## Testing

To run all tests in one go, select the __Eurofurence__ scheme. Then in the test navigator, make sure the "All Tests" test plan is active and hit `Product > Test` (or `⌘ + U`). Note this may take a minute or two. Alternatively, to run specific test targets, activate the appropriate scheme or change test plan.

We aim for as high coverage as possible to minimize the change of regressions slipping through the cracks. Each package comes with its own flavour of testing to consider, as documented below. New tests do not need to be added for refactoring (assuming the strict definition of refactoring is adhered to!).

### Model

The model package is the backbone for the app's data storage and logic, and is therefore heavily unit tested. Adapters to other frameworks have their own tests within the __EurofurenceModelAdapterTests__ bundle.

### Application

As much of the application logic should be covered by unit tests as possible, diminishing in value the closer to the view tier you get. As it's particularly difficult to write maintainable tests at the `UIViewController` (and friends) tier, these behaviours can be covered in wider XCUITests in the __EurofurenceTests__ bundle (but remain optional, assuming the behaviour is appropriatley structured in the higher tiers).

### Extensions

As unit test bundles cannot be injected into extension processes, the code for the extension should be lifted into its own package and tested there. Inverting extension specific dependencies should enable full test coverage for the extension.

## Contributing

Any bugs or prospective chunks of work should be [raised as issues](https://github.com/eurofurence/ef-app_ios/issues/new).
