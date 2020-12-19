import Eurofurence
import XCTest

class ApplicationInfoPropertyListShould: XCTestCase {

    func testContainTheCalendarUsageKey() throws {
        try assertValue(
            "Eurofurence uses your calendar to add events and alerts",
            forInfoPlistKey: "NSCalendarsUsageDescription"
        )
    }
    
    func testDesignateActivityTypes() throws {
        try assertValue([
            "ViewDealerIntent",
            "ViewEventIntent",
            "ViewEventsIntent",
            "org.eurofurence.activity.view-dealer",
            "org.eurofurence.activity.view-event"
        ], forInfoPlistKey: "NSUserActivityTypes")
    }
    
    func testContainTheCameraUsageKey() throws {
        try assertValue(
            "Eurofurence uses the camera to capture photos when submitting Artist Alley table registrations",
            forInfoPlistKey: "NSCameraUsageDescription"
        )
    }
    
    func testSpecifyNonExcemptEncryptionNotUsed() throws {
        try assertValue(false, forInfoPlistKey: "ITSAppUsesNonExemptEncryption")
    }
    
    private func assertValue<T>(
        _ expected: T,
        forInfoPlistKey key: String,
        _ line: UInt = #line
    ) throws where T: Equatable {
        let bundle = Bundle(for: AppDelegate.self)
        let objectForKey = bundle.object(forInfoDictionaryKey: key)
        let value = try XCTUnwrap(objectForKey as? T, line: line)
        
        XCTAssertEqual(expected, value, line: line)
    }

}
