@testable import Eurofurence
import XCTest

class ApplicationInfoPropertyListShould: XCTestCase {

    private func objectFromMainBundlePropertyList<T>(forInfoDictionaryKey key: String) -> T? {
        let bundle = Bundle(for: AppDelegate.self)
        return bundle.object(forInfoDictionaryKey: key) as? T
    }

    func testContainTheCalendarUsageKey() {
        let calendarUsageDescription: String? = objectFromMainBundlePropertyList(forInfoDictionaryKey: "NSCalendarsUsageDescription")
        let expectedDescription = "Eurofurence uses your calendar to add events and alerts"

        XCTAssertEqual(expectedDescription, calendarUsageDescription)
    }
    
    func testDesignateEventActivityType() {
        let activityTypes: [String]? = objectFromMainBundlePropertyList(forInfoDictionaryKey: "NSUserActivityTypes")
        XCTAssert(activityTypes?.contains("org.eurofurence.activity.view-event") == true)
    }
    
    func testDesignateDealerActivityType() {
        let activityTypes: [String]? = objectFromMainBundlePropertyList(forInfoDictionaryKey: "NSUserActivityTypes")
        XCTAssert(activityTypes?.contains("org.eurofurence.activity.view-dealer") == true)
    }
    
    func testContainTheCameraUsageKey() {
        let cameraUsageDescription: String? = objectFromMainBundlePropertyList(forInfoDictionaryKey: "NSCameraUsageDescription")
        let expected = "Eurofurence uses the camera to capture photos when submitting Artist Alley table registrations"
        
        XCTAssertEqual(expected, cameraUsageDescription)
    }

}
