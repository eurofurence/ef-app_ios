import XCTest

class LaunchPerformanceTest: XCTestCase {

    func testLaunchPerformance() throws {
        guard #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) else { return }
        
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
