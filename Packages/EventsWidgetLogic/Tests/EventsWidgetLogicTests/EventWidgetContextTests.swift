import EventsWidgetLogic
import XCTest

class EventWidgetContextTests: XCTestCase {
    
    func testSmallWidget() {
        assertEventCount(accessibilitySize: .standard, widgetSize: .small, is: 2)
        assertEventCount(accessibilitySize: .large, widgetSize: .small, is: 1)
    }
    
    func testMediumWidget() {
        assertEventCount(accessibilitySize: .standard, widgetSize: .medium, is: 3)
        assertEventCount(accessibilitySize: .large, widgetSize: .medium, is: 2)
    }
    
    func testLargeWidget() {
        assertEventCount(accessibilitySize: .standard, widgetSize: .large, is: 5)
        assertEventCount(accessibilitySize: .large, widgetSize: .large, is: 3)
    }
    
    private func assertEventCount(
        accessibilitySize: EventWidgetContext.AccessibilityCategory,
        widgetSize: EventWidgetContext.WidgetSize,
        is expected: Int,
        line: UInt = #line
    ) {
        let context = EventWidgetContext(accessibilityCategory: accessibilitySize, widgetSize: widgetSize)
        let actual = context.recommendedNumberOfEvents
        
        XCTAssertEqual(
            expected,
            actual,
            "Accessibility Size: \(accessibilitySize), Widget Size: \(widgetSize)",
            line: line
        )
    }
    
}
