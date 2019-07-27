@testable import Eurofurence
import EurofurenceModelTestDoubles
import XCTest

class WhenInvokingShareEventCommand: XCTestCase {

    func testTheShareHandlerIsInvokedWithTheEventURL() {
        let event = FakeEvent.random
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        
        let command = visitor.visited(ofKind: ShareEventActionViewModel.self)
        let actionVisitor = CapturingEventActionViewModelVisitor()
        let sender = self
        command?.describe(to: actionVisitor)
        command?.perform(sender: sender)
        
        XCTAssertEqual(actionVisitor.actionTitle, .share)
        XCTAssertEqual(event.shareableURL, (context.shareService.sharedItem as? URL))
        XCTAssertTrue(sender === (context.shareService.sharedItemSender as AnyObject))
    }

}
