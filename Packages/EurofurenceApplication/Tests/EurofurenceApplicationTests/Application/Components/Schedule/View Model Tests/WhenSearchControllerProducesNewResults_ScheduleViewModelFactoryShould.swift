import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSearchControllerProducesNewResults_ScheduleViewModelFactoryShould: XCTestCase {

    func testGroupTheResultsByStartTimeWithDayAndTimeGroupTitle() {
        let firstGroupDate = Date.random
        let a = FakeEvent.random
        a.startDate = firstGroupDate
        let b = FakeEvent.random
        b.startDate = firstGroupDate
        let c = FakeEvent.random
        c.startDate = firstGroupDate
        let firstGroupEvents = [a, b, c].sorted(by: { $0.title < $1.title })

        let secondGroupDate = firstGroupDate.addingTimeInterval(100)
        let d = FakeEvent.random
        d.startDate = secondGroupDate
        let e = FakeEvent.random
        e.startDate = secondGroupDate
        let secondGroupEvents = [d, e].sorted(by: { $0.title < $1.title })

        let results = firstGroupEvents + secondGroupEvents
        let favouriteEvent = firstGroupEvents.randomElement().element
        favouriteEvent.favourite()
        let eventsService = FakeEventsService()
        eventsService.allEvents = [a, b, c, d, e]
        eventsService.events = [a, b, c, d, e]

        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        context.makeSearchViewModel()

        eventsService.lastProducedSearchController?.simulateSearchResultsChanged(results)

        let groups = [ScheduleEventGroupViewModelAssertion.Group(date: firstGroupDate, events: firstGroupEvents),
                      ScheduleEventGroupViewModelAssertion.Group(date: secondGroupDate, events: secondGroupEvents)]

        ScheduleEventGroupViewModelAssertion.assertionForSearchEventViewModels(context: context)
            .assertEventGroupViewModels(context.searchViewModelDelegate.capturedSearchResults, isModeledBy: groups)
    }

    func testProvideTheExpectedIdentifier() {
        let firstGroupDate = Date.random
        let a = FakeEvent.random
        a.startDate = firstGroupDate
        let b = FakeEvent.random
        b.startDate = firstGroupDate
        let c = FakeEvent.random
        c.startDate = firstGroupDate
        let firstGroupEvents = [a, b, c].sorted(by: { $0.title < $1.title })

        let secondGroupDate = firstGroupDate.addingTimeInterval(100)
        let d = FakeEvent.random
        d.startDate = secondGroupDate
        let e = FakeEvent.random
        e.startDate = secondGroupDate
        let secondGroupEvents = [d, e].sorted(by: { $0.title < $1.title })

        let results = firstGroupEvents + secondGroupEvents
        let eventsService = FakeEventsService()

        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        let viewModel = context.makeSearchViewModel()

        eventsService.lastProducedSearchController?.simulateSearchResultsChanged(results)
        let randomEventInGroupOne = firstGroupEvents.randomElement()
        let indexPath = IndexPath(item: randomEventInGroupOne.index, section: 0)
        let expected = randomEventInGroupOne.element.identifier
        let actual = viewModel?.identifierForEvent(at: indexPath)

        XCTAssertEqual(expected, actual)
    }

}
