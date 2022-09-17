import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class LoginAPITests: XCTestCase {

    class CapturingV2LoginObserver {

        private(set) var capturedLoginResponse: LoginResponse?
        private(set) var notifiedLoginFailed = false
        func observe(_ result: LoginResponse?) {
            capturedLoginResponse = result
            notifiedLoginFailed = result == nil
        }

    }

    var api: JSONAPI!
    var jsonSession: CapturingJSONSession!
    var apiUrl: APIURLProviding!

    override func setUp() {
        super.setUp()

        jsonSession = CapturingJSONSession()
        apiUrl = StubAPIURLProviding()
        api = JSONAPI(jsonSession: jsonSession, apiUrl: apiUrl)
    }

    private func makeSuccessfulLoginPayload(
        username: String = "",
        userID: String = "0",
        authToken: String = "",
        validUntil: String = "2017-07-17T19:45:22.666Z"
    ) -> [String: String] {
        return ["Username": username,
                "Uid": userID,
                "Token": authToken,
                "TokenValidUntil": validUntil]
    }

    private func makeSuccessfulLoginData(
        username: String = "",
        userID: String = "0",
        authToken: String = "",
        validUntil: String = "2017-07-17T19:45:22.666Z"
    ) -> Data {
        serializeJSONObjectIntoData(makeSuccessfulLoginPayload(
            username: username,
            userID: userID,
            authToken: authToken,
            validUntil: validUntil
        ))
    }

    private func makeObserverForVerifyingLoginResponse(missingKey: String) -> CapturingV2LoginObserver {
        var payload = makeSuccessfulLoginPayload()
        payload.removeValue(forKey: missingKey)
        return makeObserverForVerifyingLoginResponse(payload)
    }

    private func makeObserverForVerifyingLoginResponse(_ payload: [String: String]) -> CapturingV2LoginObserver {
        let data = serializeJSONObjectIntoData(payload)
        return makeObserverForVerifyingLoginResponse(data)
    }

    private func makeObserverForVerifyingLoginResponse(_ data: Data?) -> CapturingV2LoginObserver {
        let loginResponseObserver = CapturingV2LoginObserver()
        performLogin(makeLoginParameters(), completionHandler: loginResponseObserver.observe)
        jsonSession.invokeLastPOSTCompletionHandler(responseData: data)

        return loginResponseObserver
    }
    
    private func makeLoginParameters(
        regNo: Int = 0,
        username: String = "Username",
        password: String = "Password"
    ) -> LoginRequest {
        return LoginRequest(regNo: regNo, username: username, password: password)
    }

    private func performLogin(
        _ request: LoginRequest,
        completionHandler: @escaping (LoginResponse?) -> Void = { _ in }
    ) {
        api.performLogin(request: request, completionHandler: completionHandler)
    }
    
    private func serializeJSONObjectIntoData(_ jsonObject: Any) -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: jsonObject, options: [])
        } catch {
            fatalError("JSON not serialized - the following should be valid: \(jsonObject)")
        }
    }

    func testTheLoginEndpointShouldReceieveRequest() {
        performLogin(makeLoginParameters())
        XCTAssertEqual(apiUrl.url + "Tokens/RegSys", jsonSession.postedURL)
    }

    func testTheLoginEndpointShouldNotReceieveRequestUntilCallingLogin() {
        XCTAssertNil(jsonSession.postedURL)
    }

    func testTheLoginRequestShouldReceieveJSONPayloadWithRegNo() {
        let registrationNumber = 42
        performLogin(makeLoginParameters(regNo: registrationNumber))

        XCTAssertEqual(registrationNumber, jsonSession.postedJSONValue(forKey: "RegNo"))
    }

    func testTheLoginRequestShouldReceieveJSONPayloadWithUsername() {
        let username = "Some awesome guy"
        performLogin(makeLoginParameters(username: username))

        XCTAssertEqual(username, jsonSession.postedJSONValue(forKey: "Username"))
    }

    func testTheLoginRequestShouldReceieveJSONPayloadWithPassword() {
        let password = "It's a secret"
        performLogin(makeLoginParameters(password: password))

        XCTAssertEqual(password, jsonSession.postedJSONValue(forKey: "Password"))
    }

    func testLoginResponseReturnsNilDataShouldTellTheObserverLoginFailed() {
        let loginResponseObserver = makeObserverForVerifyingLoginResponse(nil)
        XCTAssertTrue(loginResponseObserver.notifiedLoginFailed)
    }

    func testLoginResponseReturnsInvalidJSONShouldTellTheObserverLoginFailed() {
        let loginResponseObserver = makeObserverForVerifyingLoginResponse("Not json!".data(using: .utf8))
        XCTAssertTrue(loginResponseObserver.notifiedLoginFailed)
    }

    func testLoginResponseReturnsWrongRootJSONTypeShouldTellTheObserverLoginFailed() {
        let loginResponseObserver = makeObserverForVerifyingLoginResponse("[]".data(using: .utf8))
        XCTAssertTrue(loginResponseObserver.notifiedLoginFailed)
    }

    func testLoginResponseMissingUsernameFieldShouldTellTheObserverLoginFailed() {
        let loginResponseObserver = makeObserverForVerifyingLoginResponse(missingKey: "Username")
        XCTAssertTrue(loginResponseObserver.notifiedLoginFailed)
    }

    func testLoginResponseMissingUserIDFieldShouldTellTheObserverLoginFailed() {
        let loginResponseObserver = makeObserverForVerifyingLoginResponse(missingKey: "Uid")
        XCTAssertTrue(loginResponseObserver.notifiedLoginFailed)
    }

    func testLoginResponseMissingTokenFieldShouldTellTheObserverLoginFailed() {
        let loginResponseObserver = makeObserverForVerifyingLoginResponse(missingKey: "Token")
        XCTAssertTrue(loginResponseObserver.notifiedLoginFailed)
    }

    func testLoginResponseMissingTokenExpiryFieldShouldTellTheObserverLoginFailed() {
        let loginResponseObserver = makeObserverForVerifyingLoginResponse(missingKey: "TokenValidUntil")
        XCTAssertTrue(loginResponseObserver.notifiedLoginFailed)
    }

    func testLoginResponseContainingTokenExpiryAsSomethingOtherThanExpectedDateShouldTellTheObserverLoginFailed() {
        let payload = makeSuccessfulLoginPayload(validUntil: "Some weird format")
        let loginResponseObserver = makeObserverForVerifyingLoginResponse(payload)

        XCTAssertTrue(loginResponseObserver.notifiedLoginFailed)
    }

    func testLoggingInSuccessfullyShouldReturnResponseWithUsername() {
        let username = "User"
        let data = makeSuccessfulLoginData(username: username)
        let observer = makeObserverForVerifyingLoginResponse(data)

        XCTAssertEqual(username, observer.capturedLoginResponse?.username)
    }

    func testLoggingInSuccessfullyShouldReturnResponseWithAuthToken() {
        let authToken = "Auth Token"
        let data = makeSuccessfulLoginData(authToken: authToken)
        let observer = makeObserverForVerifyingLoginResponse(data)

        XCTAssertEqual(authToken, observer.capturedLoginResponse?.token)
    }

    func testLoggingInSuccessfullyShouldReturnResponseWithUserID() {
        let uid = "RegSys:23:99999"
        let data = makeSuccessfulLoginData(userID: uid)
        let observer = makeObserverForVerifyingLoginResponse(data)

        XCTAssertEqual(uid, observer.capturedLoginResponse?.userIdentifier)
    }

    func testLoggingInSuccessfullyShouldReturnResponseWithAuthTokenExpiry() {
        let data = makeSuccessfulLoginData(validUntil: "2017-07-17T19:45:22.666Z")
        let observer = makeObserverForVerifyingLoginResponse(data)
        let expectedComponents = DateComponents(year: 2017, month: 7, day: 17, hour: 19, minute: 45, second: 22)
        let receievedDate = observer.capturedLoginResponse?.tokenValidUntil
        var actualComponents: DateComponents?
        let desiredComponents: [Calendar.Component] = [.year, .month, .day, .hour, .minute, .second]
        if let receievedDate = receievedDate {
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(abbreviation: "GMT").unsafelyUnwrapped
            actualComponents = calendar.dateComponents(Set(desiredComponents), from: receievedDate)
        }

        XCTAssertEqual(expectedComponents, actualComponents)
    }

}
