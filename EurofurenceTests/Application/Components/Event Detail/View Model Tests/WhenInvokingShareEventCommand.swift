import Eurofurence
import EurofurenceModelTestDoubles
import XCTest

class WhenInvokingShareEventCommand: XCTestCase {

    func testTheShareHandlerIsInvokedWithTheEvent() {
        let event = FakeEvent.random
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        
        let command = visitor.visited(ofKind: ShareEventActionViewModel.self)
        let actionVisitor = CapturingEventActionViewModelVisitor()
        let sender = self
        command?.describe(to: actionVisitor)
        command?.perform(sender: sender)
        
        XCTAssertEqual(actionVisitor.actionTitle, .share)
        XCTAssertTrue(event === context.shareService.sharedItem as? FakeEvent)
        XCTAssertTrue(sender === (context.shareService.sharedItemSender as AnyObject))
    }

}
