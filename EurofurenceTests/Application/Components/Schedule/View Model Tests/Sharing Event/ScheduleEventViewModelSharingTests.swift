import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class ScheduleEventViewModelSharingTests: XCTestCase {
    
    func testSharingEvent() {
        let eventsService = FakeEventsService()
        let event = FakeEvent.random
        eventsService.allEvents = [event]
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        context.makeViewModel()
        let eventViewModel = context.eventsViewModels.first?.events.first
        let sender = "Sender"
        eventViewModel?.share(sender)
        
        XCTAssertEqual(event.makeContentURL(), context.shareService.sharedItem as? URL)
        XCTAssertEqual(sender, context.shareService.sharedItemSender as? String)
    }

}
