import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenFetchingEventsBeforeRefreshWhenStoreHasEvents: XCTestCase {

    func testTheEventsFromTheStoreAreAdapted() throws {
        let response = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: response)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)

        try EventAssertion(context: context, modelCharacteristics: response)
            .assertEvents(observer.allEvents, characterisedBy: response.events.changed)
    }

}
