import EurofurenceApplication
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
        let sharedItem = context.shareService.sharedItem as? EventActivityItemSource
        
        XCTAssertEqual(EventActivityItemSource(event: event), sharedItem)
        XCTAssertEqual(sender, context.shareService.sharedItemSender as? String)
    }

}
