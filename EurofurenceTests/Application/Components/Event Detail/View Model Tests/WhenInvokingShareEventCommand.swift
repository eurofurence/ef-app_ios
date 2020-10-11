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
        let sharedItem = context.shareService.sharedItem as? EventActivityItemSource
        
        XCTAssertEqual(actionVisitor.actionTitle, .share)
        XCTAssertEqual(EventActivityItemSource(event: event), sharedItem)
        XCTAssertTrue(sender === (context.shareService.sharedItemSender as AnyObject))
    }

}
