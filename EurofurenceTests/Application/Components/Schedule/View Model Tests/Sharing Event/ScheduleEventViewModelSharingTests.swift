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
        
        XCTAssertTrue(event === context.shareService.sharedItem as? FakeEvent)
        XCTAssertEqual(sender, context.shareService.sharedItemSender as? String)
    }

}
