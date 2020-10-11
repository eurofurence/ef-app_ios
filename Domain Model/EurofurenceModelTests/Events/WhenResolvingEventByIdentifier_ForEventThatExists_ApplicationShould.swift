import EurofurenceModel
import XCTest

class WhenResolvingEventByIdentifier_ForEventThatExists_ApplicationShould: XCTestCase {

    func testResolveTheExpectedEvent() throws {
        let response = ModelCharacteristics.randomWithoutDeletions
        let context = EurofurenceSessionTestBuilder().build()
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let characteristics = response.events.changed.randomElement().element
        let actual = context.eventsService.fetchEvent(identifier: EventIdentifier(characteristics.identifier))

        try EventAssertion(context: context, modelCharacteristics: response)
            .assertEvent(actual, characterisedBy: characteristics)
    }

}
