import ComponentBase
import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTEurofurenceModel

class ScheduleEventViewModelSharingTests: XCTestCase {
    
    func testSharingEvent() {
        let eventsService = FakeScheduleRepository()
        let event = FakeEvent.random
        eventsService.allEvents = [event]
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        context.makeViewModel()
        let eventViewModel = context.eventsViewModels.first?.events.first
        let sender = "Sender"
        eventViewModel?.share(sender)
        let sharedItem = context.shareService.sharedItem as? EventActivityItemSource
        
        XCTAssertEqual(EventActivityItemSource(event: event), sharedItem)
        XCTAssertEqual(sender, context.shareService.sharedItemSender as? String)
    }

}
