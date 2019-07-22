import XCTest

class WhenAutofillingPassword_LoginPresenterShould: XCTestCase {

    func testResetRegistrationNumberWithNonNumerics() {
        assertRegistrationNumber("A", isOverriddenWith: "")
    }
    
    func testNotResetRegistrationNumberWithOnlyNumerics() {
        assertRegistrationNumber("1", isOverriddenWith: nil)
    }
    
    func testMaintainDigitsMixedWithNonNumerics() {
        assertRegistrationNumber("A123B", isOverriddenWith: "123")
    }
    
    private func assertRegistrationNumber(
        _ registrationNumber: String,
        isOverriddenWith overriddenString: String?,
        _ line: UInt = #line
    ) {
        let context = LoginPresenterTestBuilder().build()
        context.updateRegistrationNumber(registrationNumber)
        
        XCTAssertEqual(overriddenString, context.loginSceneFactory.stubScene.capturedOverriddenRegistrationNumber, line: line)
    }

}
