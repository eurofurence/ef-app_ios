import Eurofurence
import EurofurenceModel
import XCTest

class ApplicationSignificantTimeChangeAdapterTests: XCTestCase {

    func testTellsTheDelegateWhenSignificantTimeChangeNotificationPublished() {
        let adapter = ApplicationSignificantTimeChangeAdapter()
        let delegate = CapturingSignificantTimeChangeAdapterDelegate()
        adapter.setDelegate(delegate)
        NotificationCenter.default.post(
            name: UIApplication.significantTimeChangeNotification, 
            object: nil,
            userInfo: nil
        )

        XCTAssertTrue(delegate.toldSignificantTimeChangeOccurred)
    }

}
