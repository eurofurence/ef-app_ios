import EurofurenceClipLogic
import XCTest

class MockClipFallbackContent: ClipContentScene {
    
    enum Content: Equatable {
        case unset
        case events
        case dealers
    }
    
    private(set) var displayedContent: Content = .unset
    
    func prepareForShowingEvents() {
        displayedContent = .events
    }
    
    func prepareForShowingDealers() {
        displayedContent = .dealers
    }
    
    func assertNotDisplayingAnything(file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(displayedContent, .unset, file: file, line: line)
    }
    
    func assertDisplaying(_ expected: Content, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(displayedContent, expected, file: file, line: line)
    }
    
}
