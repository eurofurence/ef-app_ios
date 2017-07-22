//
//  FirebaseRemoteNotificationsTokenRegistrationTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class FirebaseRemoteNotificationsTokenRegistrationTests: XCTestCase {
    
    private struct Context {
        var tokenRegistration: FirebaseRemoteNotificationsTokenRegistration
        var capturingFirebaseAdapter: CapturingFirebaseAdapter
        var capturingFCMDeviceRegister: CapturingFCMDeviceRegistration

        func registerDeviceToken(deviceToken: Data = Data(), userAuthenticationToken: String = "") {
            tokenRegistration.registerRemoteNotificationsDeviceToken(deviceToken,
                                                                     userAuthenticationToken: userAuthenticationToken)
        }
    }

    private func assembleApp(configuration: BuildConfiguration, version: String = "") -> Context {
        let buildConfigurationProviding = StubBuildConfigurationProviding(configuration: configuration)
        let appVersionProviding = StubAppVersionProviding(version: version)
        let capturingFirebaseAdapter = CapturingFirebaseAdapter()
        let capturingFCMDeviceRegister = CapturingFCMDeviceRegistration()
        let tokenRegistration = FirebaseRemoteNotificationsTokenRegistration(buildConfiguration: buildConfigurationProviding,
                                                                             appVersion: appVersionProviding,
                                                                             firebaseAdapter: capturingFirebaseAdapter,
                                                                             fcmRegistration: capturingFCMDeviceRegister)

        return Context(tokenRegistration: tokenRegistration,
                       capturingFirebaseAdapter: capturingFirebaseAdapter,
                       capturingFCMDeviceRegister: capturingFCMDeviceRegister)
    }

    func testForDebugConfigurationTestNotificationsShouldBeSubscribed() {
        let context = assembleApp(configuration: .debug)
        context.registerDeviceToken()

        XCTAssertTrue(context.capturingFirebaseAdapter.subscribedToTestNotifications)
    }

    func testForReleaseConfigurationLiveNotificationsShouldBeSubscribed() {
        let context = assembleApp(configuration: .release)
        context.registerDeviceToken()

        XCTAssertTrue(context.capturingFirebaseAdapter.subscribedToLiveNotifications)
    }

    func testForDebugConfigurationLiveNotificationsShouldNotBeSubscribed() {
        let context = assembleApp(configuration: .debug)
        context.registerDeviceToken()

        XCTAssertFalse(context.capturingFirebaseAdapter.subscribedToLiveNotifications)
    }

    func testForReleaseConfigurationTestNotificationsShouldNotBeSubscribed() {
        let context = assembleApp(configuration: .release)
        context.registerDeviceToken()

        XCTAssertFalse(context.capturingFirebaseAdapter.subscribedToTestNotifications)
    }

    func testForDebugConfigurationLiveNotificationsShouldBeUnsubscribed() {
        let context = assembleApp(configuration: .debug)
        context.registerDeviceToken()

        XCTAssertTrue(context.capturingFirebaseAdapter.unsubscribedFromLiveNotifications)
    }

    func testForReleaseConfigurationTestNotificationsShouldBeUnsubscribed() {
        let context = assembleApp(configuration: .release)
        context.registerDeviceToken()

        XCTAssertTrue(context.capturingFirebaseAdapter.unsubscribedFromTestNotifications)
    }

    func testForDebugConfigurationTestNotificationsShouldNotBeUnsubscribed() {
        let context = assembleApp(configuration: .debug)
        context.registerDeviceToken()

        XCTAssertFalse(context.capturingFirebaseAdapter.unsubscribedFromTestNotifications)
    }

    func testForReleaseConfigurationLiveNotificationsShouldNotBeUnsubscribed() {
        let context = assembleApp(configuration: .release)
        context.registerDeviceToken()

        XCTAssertFalse(context.capturingFirebaseAdapter.unsubscribedFromLiveNotifications)
    }

    func testForDebugConfigurationNotRegisterForTestNotificationsUntilWeActuallyReceievePushToken() {
        let context = assembleApp(configuration: .debug)
        XCTAssertFalse(context.capturingFirebaseAdapter.subscribedToTestNotifications)
    }

    func testForReleaseConfigurationNotRegisterForLiveNotificationsUntilWeActuallyReceievePushToken() {
        let context = assembleApp(configuration: .release)
        XCTAssertFalse(context.capturingFirebaseAdapter.subscribedToLiveNotifications)
    }

    func testForDebugConfigurationNotUnregisterFromLiveNotificationsUntilWeActuallyReceievePushToken() {
        let context = assembleApp(configuration: .debug)
        XCTAssertFalse(context.capturingFirebaseAdapter.unsubscribedFromLiveNotifications)
    }

    func testForReleaseConfigurationNotUnregisterFromTestNotificationsUntilWeActuallyReceievePushToken() {
        let context = assembleApp(configuration: .release)
        XCTAssertFalse(context.capturingFirebaseAdapter.unsubscribedFromTestNotifications)
    }

    func testSetTheTokenOntoTheNotificationsService() {
        let context = assembleApp(configuration: .debug)
        let deviceToken = "I'm a token".data(using: .utf8)!
        context.registerDeviceToken(deviceToken: deviceToken)

        XCTAssertEqual(deviceToken, context.capturingFirebaseAdapter.registeredDeviceToken)
    }

    func testForAnyConfigurationTheAnnouncementsTopicShouldBeSubscribedTo() {
        let context = assembleApp(configuration: .debug)
        context.registerDeviceToken()

        XCTAssertTrue(context.capturingFirebaseAdapter.subscribedToAnnouncements)
    }

    func testForAnyConfigurationTheAnnouncementsTopicShouldNotBeSubscribedToUntilWeActuallyReceievePushToken() {
        let context = assembleApp(configuration: .debug)
        XCTAssertFalse(context.capturingFirebaseAdapter.subscribedToAnnouncements)
    }

    func testReportTheFirebaseFCMTokenToTheFCMDeviceRegister() {
        let context = assembleApp(configuration: .debug)
        let stubFCMToken = "Stub token"
        context.capturingFirebaseAdapter.fcmToken = stubFCMToken
        context.registerDeviceToken()

        XCTAssertEqual(stubFCMToken, context.capturingFCMDeviceRegister.capturedFCM)
    }

    func testForDebugConfigurationRegisterTheDebugTopicToTheFCMDeviceRegister() {
        let context = assembleApp(configuration: .debug)
        context.registerDeviceToken()

        XCTAssertTrue(context.capturingFCMDeviceRegister.registeredTestTopic)
    }

    func testForDebugConfigurationRegisterTheAnnouncementsTopicToTheFCMDeviceRegister() {
        let context = assembleApp(configuration: .debug)
        context.registerDeviceToken()

        XCTAssertTrue(context.capturingFCMDeviceRegister.registeredAnnouncementsTopic)
    }

    func testForReleaseConfigurationRegisterTheLiveTopicToTheFCMDeviceRegister() {
        let context = assembleApp(configuration: .release)
        context.registerDeviceToken()

        XCTAssertTrue(context.capturingFCMDeviceRegister.registeredLiveTopic)
    }

    func testForReleaseConfigurationNotRegisterTheTestTopicToTheFCMDeviceRegister() {
        let context = assembleApp(configuration: .release)
        context.registerDeviceToken()

        XCTAssertFalse(context.capturingFCMDeviceRegister.registeredTestTopic)
    }

    func testForDebugConfigurationNotRegisterTheLiveTopicToTheFCMDeviceRegister() {
        let context = assembleApp(configuration: .debug)
        context.registerDeviceToken()

        XCTAssertFalse(context.capturingFCMDeviceRegister.registeredLiveTopic)
    }

    func testRegisterTheiOSTopicForDebugConfiguration() {
        let context = assembleApp(configuration: .debug)
        context.registerDeviceToken()

        XCTAssertTrue(context.capturingFCMDeviceRegister.registeredToiOSTopic)
    }

    func testRegisterTheiOSTopicForReleaseConfiguration() {
        let context = assembleApp(configuration: .release)
        context.registerDeviceToken()

        XCTAssertTrue(context.capturingFCMDeviceRegister.registeredToiOSTopic)
    }

    func testRegisterTheDebugTopicForDebugBuilds() {
        let context = assembleApp(configuration: .debug)
        context.registerDeviceToken()

        XCTAssertTrue(context.capturingFCMDeviceRegister.registeredDebugTopic)
    }

    func testNotRegisterTheDebugTopicForReleaseBuilds() {
        let context = assembleApp(configuration: .release)
        context.registerDeviceToken()

        XCTAssertFalse(context.capturingFCMDeviceRegister.registeredDebugTopic)
    }
    
    func testRegisterTheVersionTopicForReleaseBuildsUsingTheVersionFromTheProvider() {
        let version = "2.0.0"
        let context = assembleApp(configuration: .release, version: version)
        context.registerDeviceToken()
        
        XCTAssertTrue(context.capturingFCMDeviceRegister.registeredVersionTopic(with: version))
    }
    
    func testRegisterTheVersionTopicForDebugBuildsUsingTheVersionFromTheProvider() {
        let version = "2.0.0"
        let context = assembleApp(configuration: .debug, version: version)
        context.registerDeviceToken()
        
        XCTAssertTrue(context.capturingFCMDeviceRegister.registeredVersionTopic(with: version))
    }
    
    func testRegisteringDeviceTokenShouldProvideTheUserAuthenticationToken() {
        let authenticationToken = "Token"
        let context = assembleApp(configuration: .debug)
        context.registerDeviceToken(userAuthenticationToken: authenticationToken)
        
        XCTAssertEqual(authenticationToken, context.capturingFCMDeviceRegister.capturedAuthenticationToken)
    }
    
}
