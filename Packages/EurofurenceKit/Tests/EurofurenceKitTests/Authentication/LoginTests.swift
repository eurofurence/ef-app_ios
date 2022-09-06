import EurofurenceKit
import XCTAsyncAssertions
import XCTest

class LoginTests: XCTestCase {
    
    func testInitiallyCannotLogin() {
        let login = Login()
        XCTAssertFalse(login.canLogin)
    }
    
    func testCanLoginWhenAllParametersSupplied() {
        let login = Login()
        login.registrationNumber = 42
        login.username = "Some Guy"
        login.password = "p455w0rd!"
        
        XCTAssertTrue(login.canLogin)
    }
    
    func testCannotLoginWhenMissingUsername() {
        let login = Login()
        login.registrationNumber = 42
        login.password = "p455w0rd!"
        login.username = ""
        
        XCTAssertFalse(login.canLogin)
    }
    
    func testCannotLoginWhenMissingPassword() {
        let login = Login()
        login.registrationNumber = 42
        login.username = "Some Guy"
        login.password = ""
        
        XCTAssertFalse(login.canLogin)
    }
    
    func testLoginNotAttemptedWhenMissingRegistrationNumber() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let login = Login()
        login.username = "Some Guy"
        login.password = "p455w0rd!"
        
        await XCTAssertEventuallyNoThrows { try await scenario.model.signIn(with: login) }
    }
    
    func testLoginNotAttemptedWhenMissingUsername() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let login = Login()
        login.registrationNumber = 42
        login.password = "p455w0rd!"
        
        await XCTAssertEventuallyNoThrows { try await scenario.model.signIn(with: login) }
    }
    
    func testLoginNotAttemptedWhenMissingPassword() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        let login = Login()
        login.registrationNumber = 42
        login.username = "Some Guy"
        
        await XCTAssertEventuallyNoThrows { try await scenario.model.signIn(with: login) }
    }
    
}
