import EurofurenceModel
import XCTest

class WhenSearchingForEvents_ApplicationShould: XCTestCase {

    func testReturnExactMatchesOnTitles() throws {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        let eventsSearchController = context.eventsService.makeEventsSearchController()
        let randomEvent = syncResponse.events.changed.randomElement().element
        let delegate = CapturingEventsSearchControllerDelegate()
        eventsSearchController.setResultsDelegate(delegate)
        eventsSearchController.changeSearchTerm(randomEvent.title)

        try EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertEvents(delegate.capturedSearchResults, characterisedBy: [randomEvent])
    }

    func testReturnFuzzyMatchesOnTitles() throws {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        let eventsSearchController = context.eventsService.makeEventsSearchController()
        let randomEvent = syncResponse.events.changed.randomElement().element
        let delegate = CapturingEventsSearchControllerDelegate()
        eventsSearchController.setResultsDelegate(delegate)
        let partialTitle = String(randomEvent.title.dropLast())
        eventsSearchController.changeSearchTerm(partialTitle)

        try EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertEvents(delegate.capturedSearchResults, characterisedBy: [randomEvent])
    }

    func testBeCaseInsensitive() throws {
        let context = EurofurenceSessionTestBuilder().build()
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        var event = randomEvent.element
        event.title = "iGNoRe tHe rANdoM CAsing"
        syncResponse.events.changed[randomEvent.index] = event
        context.performSuccessfulSync(response: syncResponse)
        let eventsSearchController = context.eventsService.makeEventsSearchController()
        let delegate = CapturingEventsSearchControllerDelegate()
        eventsSearchController.setResultsDelegate(delegate)
        eventsSearchController.changeSearchTerm("random")

        try EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertEvents(delegate.capturedSearchResults, characterisedBy: [event])
    }

}
