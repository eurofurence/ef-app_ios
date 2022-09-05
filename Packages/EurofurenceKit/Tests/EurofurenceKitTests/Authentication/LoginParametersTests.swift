import EurofurenceKit
import XCTest
import XCTAsyncAssertions

class LoginParametersTests: XCTestCase {
    
    func testInitiallyCannotLogin() {
        let parameters = LoginParameters()
        XCTAssertFalse(parameters.canLogin)
    }
    
    func testCanLoginWhenAllParametersSupplied() {
        let parameters = LoginParameters()
        parameters.registrationNumber = 42
        parameters.username = "Some Guy"
        parameters.password = "p455w0rd!"
        
        XCTAssertTrue(parameters.canLogin)
    }
    
    func testCannotLoginWhenMissingUsername() {
        let parameters = LoginParameters()
        parameters.registrationNumber = 42
        parameters.password = "p455w0rd!"
        parameters.username = ""
        
        XCTAssertFalse(parameters.canLogin)
    }
    
    func testCannotLoginWhenMissingPassword() {
        let parameters = LoginParameters()
        parameters.registrationNumber = 42
        parameters.username = "Some Guy"
        parameters.password = ""
        
        XCTAssertFalse(parameters.canLogin)
    }
    
    func testLoginNotAttemptedWhenMissingRegistrationNumber() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let parameters = LoginParameters()
        parameters.username = "Some Guy"
        parameters.password = "p455w0rd!"
        
        await XCTAssertEventuallyNoThrows { try await scenario.model.signIn(with: parameters) }
    }
    
    func testLoginNotAttemptedWhenMissingUsername() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let parameters = LoginParameters()
        parameters.registrationNumber = 42
        parameters.password = "p455w0rd!"
        
        await XCTAssertEventuallyNoThrows { try await scenario.model.signIn(with: parameters) }
    }
    
    func testLoginNotAttemptedWhenMissingPassword() async throws {
        let scenario = EurofurenceModelTestBuilder().build()
        let parameters = LoginParameters()
        parameters.registrationNumber = 42
        parameters.username = "Some Guy"
        
        await XCTAssertEventuallyNoThrows { try await scenario.model.signIn(with: parameters) }
    }
    
}
