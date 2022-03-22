import EurofurenceModel
import XCTest

class ScheduleWithoutExplicitSpecificationShould: XCTestCase {
    
    func testMakeAllEventsAvailableToDelegate_SortedByStartTime() throws {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let schedule = context.eventsService.loadSchedule()
        let delegate = CapturingScheduleDelegate()
        schedule.setDelegate(delegate)
        
        try EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertEvents(delegate.events, characterisedBy: syncResponse.events.changed)
    }
    
}
