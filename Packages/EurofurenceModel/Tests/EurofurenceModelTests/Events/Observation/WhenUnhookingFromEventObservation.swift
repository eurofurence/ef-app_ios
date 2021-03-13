import EurofurenceModel
import XCTest

class WhenUnhookingFromEventObservation: XCTestCase {

    func testChangesToFavouriteStateAreNotPassedToObserver() {
        let context = EurofurenceSessionTestBuilder().build()
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let event = characteristics.events.changed.randomElement().element
        context.performSuccessfulSync(response: characteristics)
        let entity = context.eventsService.fetchEvent(identifier: EventIdentifier(event.identifier))
        let observer = CapturingEventObserver()
        entity?.add(observer)
        entity?.remove(observer)
        entity?.favourite()
        
        XCTAssertEqual(.notFavourite, observer.eventFavouriteState)
    }

}
