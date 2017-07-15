//
//  FirebaseNotificationsTokenRegistrationTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

protocol FirebaseAdapter {

    var fcmToken: String { get }

    func setAPNSToken(deviceToken: Data)
    func subscribe(toTopic topic: String)
    func unsubscribe(fromTopic topic: String)

}

protocol FCMDeviceRegistration {

    func registerFCM(_ fcm: String, topics: [String])

}

class CapturingFirebaseAdapter: FirebaseAdapter {

    private(set) var registeredDeviceToken: Data?
    func setAPNSToken(deviceToken: Data) {
        registeredDeviceToken = deviceToken
    }

    private var subscribedTopics = [String]()
    func subscribe(toTopic topic: String) {
        subscribedTopics.append(topic)
    }

    private var unsubscribedTopics = [String]()
    func unsubscribe(fromTopic topic: String) {
        unsubscribedTopics.append(topic)
    }

    var fcmToken: String = ""

    func didSubscribeToTopic(_ topic: String) -> Bool {
        return subscribedTopics.contains(topic)
    }

    func didUnsubscribeFromTopic(_ topic: String) -> Bool {
        return unsubscribedTopics.contains(topic)
    }

    var subscribedToTestNotifications: Bool {
        return didSubscribeToTopic("test")
    }

    var subscribedToLiveNotifications: Bool {
        return didSubscribeToTopic("live")
    }

    var unsubscribedFromTestNotifications: Bool {
        return didUnsubscribeFromTopic("test")
    }

    var unsubscribedFromLiveNotifications: Bool {
        return didUnsubscribeFromTopic("live")
    }

    var subscribedToAnnouncements: Bool {
        return didSubscribeToTopic("announcements")
    }

}

class CapturingFCMDeviceRegistration: FCMDeviceRegistration {

    private(set) var capturedFCM: String?
    private var topics = [String]()
    func registerFCM(_ fcm: String, topics: [String]) {
        capturedFCM = fcm
        self.topics = topics
    }

    var registeredDebugTopic: Bool {
        return topics.contains("test")
    }

    var registeredLiveTopic: Bool {
        return topics.contains("live")
    }

    var registeredAnnouncementsTopic: Bool {
        return topics.contains("announcements")
    }

}

struct FirebaseNotificationsTokenRegistration {

    private enum Topic: String {
        case test
        case live
        case announcements
    }

    private var buildConfiguration: BuildConfigurationProviding
    private var firebaseAdapter: FirebaseAdapter
    private var fcmRegistration: FCMDeviceRegistration

    init(buildConfiguration: BuildConfigurationProviding,
         firebaseAdapter: FirebaseAdapter,
         fcmRegistration: FCMDeviceRegistration) {
        self.buildConfiguration = buildConfiguration
        self.firebaseAdapter = firebaseAdapter
        self.fcmRegistration = fcmRegistration


    }

    func registerDevicePushToken(_ token: Data) {
        firebaseAdapter.setAPNSToken(deviceToken: token)
        firebaseAdapter.subscribe(toTopic: Topic.announcements.rawValue)

        switch buildConfiguration.configuration {
        case .debug:
            fcmRegistration.registerFCM(firebaseAdapter.fcmToken, topics: ["announcements", "test"])
            firebaseAdapter.subscribe(toTopic: Topic.test.rawValue)
            firebaseAdapter.unsubscribe(fromTopic: Topic.live.rawValue)

        case .release:
            fcmRegistration.registerFCM(firebaseAdapter.fcmToken, topics: ["announcements", "live"])
            firebaseAdapter.subscribe(toTopic: Topic.live.rawValue)
            firebaseAdapter.unsubscribe(fromTopic: Topic.test.rawValue)
        }
    }

}

class FirebaseNotificationsTokenRegistrationTests: XCTestCase {
    
    struct FirebaseNotificationsTokenRegistrationTestContext {
        var tokenRegistration: FirebaseNotificationsTokenRegistration
        var capturingFirebaseAdapter: CapturingFirebaseAdapter
        var capturingFCMDeviceRegister: CapturingFCMDeviceRegistration

        func registerDeviceToken(deviceToken: Data = Data()) {
            tokenRegistration.registerDevicePushToken(deviceToken)
        }
    }

    private func assembleApp(configuration: BuildConfiguration) -> FirebaseNotificationsTokenRegistrationTestContext {
        let buildConfigurationProviding = StubBuildConfigurationProviding(configuration: configuration)
        let capturingFirebaseAdapter = CapturingFirebaseAdapter()
        let capturingFCMDeviceRegister = CapturingFCMDeviceRegistration()
        let tokenRegistration = FirebaseNotificationsTokenRegistration(buildConfiguration: buildConfigurationProviding,
                                                                       firebaseAdapter: capturingFirebaseAdapter,
                                                                       fcmRegistration: capturingFCMDeviceRegister)

        return FirebaseNotificationsTokenRegistrationTestContext(tokenRegistration: tokenRegistration,
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

        XCTAssertTrue(context.capturingFCMDeviceRegister.registeredDebugTopic)
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

        XCTAssertFalse(context.capturingFCMDeviceRegister.registeredDebugTopic)
    }

    func testForDebugConfigurationNotRegisterTheLiveTopicToTheFCMDeviceRegister() {
        let context = assembleApp(configuration: .debug)
        context.registerDeviceToken()

        XCTAssertFalse(context.capturingFCMDeviceRegister.registeredLiveTopic)
    }
    
}
