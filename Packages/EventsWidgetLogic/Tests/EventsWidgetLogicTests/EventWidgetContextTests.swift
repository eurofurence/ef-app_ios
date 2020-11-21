import EventsWidgetLogic
import XCTest

class EventWidgetContextTests: XCTestCase {
    
    func testSmallWidget() {
        assertEventCount(accessibilitySize: .large, widgetSize: .small, is: 2)
        assertEventCount(accessibilitySize: .extraLarge, widgetSize: .small, is: 2)
        assertEventCount(accessibilitySize: .extraExtraLarge, widgetSize: .small, is: 1)
        assertEventCount(accessibilitySize: .extraExtraExtraLarge, widgetSize: .small, is: 1)
    }
    
    func testMediumWidget() {
        assertEventCount(accessibilitySize: .large, widgetSize: .medium, is: 3)
        assertEventCount(accessibilitySize: .extraLarge, widgetSize: .medium, is: 2)
        assertEventCount(accessibilitySize: .extraExtraLarge, widgetSize: .medium, is: 2)
        assertEventCount(accessibilitySize: .extraExtraExtraLarge, widgetSize: .medium, is: 1)
    }
    
    func testLargeWidget() {
        assertEventCount(accessibilitySize: .large, widgetSize: .large, is: 5)
        assertEventCount(accessibilitySize: .extraLarge, widgetSize: .large, is: 4)
        assertEventCount(accessibilitySize: .extraExtraLarge, widgetSize: .large, is: 3)
        assertEventCount(accessibilitySize: .extraExtraExtraLarge, widgetSize: .large, is: 3)
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
