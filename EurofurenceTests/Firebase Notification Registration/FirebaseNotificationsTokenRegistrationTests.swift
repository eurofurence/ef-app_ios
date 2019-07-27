import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class FirebaseRemoteNotificationsTokenRegistrationTests: XCTestCase {

    private struct Context {
        var tokenRegistration: FirebaseRemoteNotificationsTokenRegistration
        var capturingFirebaseAdapter: CapturingFirebaseAdapter
        var capturingFCMDeviceRegister: CapturingFCMDeviceRegistration

        func registerDeviceToken(deviceToken: Data = Data(),
                                 userAuthenticationToken: String = "",
                                 completionHandler: ((Error?) -> Void)? = nil) {
            tokenRegistration.registerRemoteNotificationsDeviceToken(deviceToken,
                                                                     userAuthenticationToken: userAuthenticationToken) { completionHandler?($0) }
        }
    }

    private func assembleApp(configuration: BuildConfiguration, version: String = "", cid: ConventionIdentifier = ConventionIdentifier(identifier: "")) -> Context {
        let buildConfigurationProviding = StubBuildConfigurationProviding(configuration: configuration)
        let appVersionProviding = StubAppVersionProviding(version: version)
        let capturingFirebaseAdapter = CapturingFirebaseAdapter()
        let capturingFCMDeviceRegister = CapturingFCMDeviceRegistration()
        let tokenRegistration = FirebaseRemoteNotificationsTokenRegistration(buildConfiguration: buildConfigurationProviding,
                                                                             appVersion: appVersionProviding,
                                                                             conventionIdentifier: cid,
                                                                             firebaseAdapter: capturingFirebaseAdapter,
                                                                             fcmRegistration: capturingFCMDeviceRegister)

        return Context(tokenRegistration: tokenRegistration,
                       capturingFirebaseAdapter: capturingFirebaseAdapter,
                       capturingFCMDeviceRegister: capturingFCMDeviceRegister)
    }
    
    func testSubscribesToCIDTopics() {
        let cid = ConventionIdentifier(identifier: "EF25")
        let context = assembleApp(configuration: .debug, cid: cid)
        context.registerDeviceToken()
        
        XCTAssertTrue(context.capturingFirebaseAdapter.didSubscribeToTopic(.cid(cid.identifier)))
        XCTAssertTrue(context.capturingFirebaseAdapter.didSubscribeToTopic(.cidiOS(cid.identifier)))
    }

    func testSetTheTokenOntoTheNotificationsService() {
        let context = assembleApp(configuration: .debug)
        let deviceToken = unwrap("I'm a token".data(using: .utf8))
        context.registerDeviceToken(deviceToken: deviceToken)

        XCTAssertEqual(deviceToken, context.capturingFirebaseAdapter.registeredDeviceToken)
    }

    func testReportTheFirebaseFCMTokenToTheFCMDeviceRegister() {
        let context = assembleApp(configuration: .debug)
        let stubFCMToken = "Stub token"
        context.capturingFirebaseAdapter.fcmToken = stubFCMToken
        context.registerDeviceToken()

        XCTAssertEqual(stubFCMToken, context.capturingFCMDeviceRegister.capturedFCM)
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
    
    func testRegisterTheCIDTopic() {
        let cid = ConventionIdentifier(identifier: "EF25")
        let context = assembleApp(configuration: .debug, cid: cid)
        context.registerDeviceToken()
        
        XCTAssertTrue(context.capturingFCMDeviceRegister.registeredCIDTopic(with: cid.identifier))
    }

    func testRegisteringDeviceTokenShouldProvideTheUserAuthenticationToken() {
        let authenticationToken = "Token"
        let context = assembleApp(configuration: .debug)
        context.registerDeviceToken(userAuthenticationToken: authenticationToken)

        XCTAssertEqual(authenticationToken, context.capturingFCMDeviceRegister.capturedAuthenticationToken)
    }

    func testErrorsDuringFCMRegistrationArePropogatedBackThroughTheCompletionHandler() {
        let context = assembleApp(configuration: .debug)
        var observedError: NSError?
        context.registerDeviceToken { observedError = $0 as NSError? }
        let expectedError = NSError(domain: "Test", code: 0, userInfo: nil)
        context.capturingFCMDeviceRegister.completionHandler?(expectedError)

        XCTAssertEqual(expectedError, observedError)
    }

}
