import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenGroupingEventsByStartTime_ScheduleViewModelFactoryShould: XCTestCase {

    var events: [Event]!
    var eventsService: FakeEventsService!
    var context: ScheduleViewModelFactoryTestBuilder.Context!
    var expectedGroups: [ScheduleEventGroupViewModelAssertion.Group]!

    override func setUp() {
        super.setUp()

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

        events = firstGroupEvents + secondGroupEvents
        eventsService = FakeEventsService()

        context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()

        expectedGroups = [ScheduleEventGroupViewModelAssertion.Group(date: firstGroupDate, events: firstGroupEvents),
                          ScheduleEventGroupViewModelAssertion.Group(date: secondGroupDate, events: secondGroupEvents)]
    }

    private func simulateEventsChanged() {
        eventsService.simulateEventsChanged(events)
    }

    func testGroupEventsByStartTime() {
        simulateEventsChanged()
        context.makeViewModel()

        ScheduleEventGroupViewModelAssertion.assertionForEventViewModels(context: context)
            .assertEventGroupViewModels(context.eventsViewModels, isModeledBy: expectedGroups)
    }

    func testProvideUpdatedGroupsToDelegate() {
        context.makeViewModel()
        simulateEventsChanged()

        ScheduleEventGroupViewModelAssertion.assertionForEventViewModels(context: context)
            .assertEventGroupViewModels(context.eventsViewModels, isModeledBy: expectedGroups)
    }

    func testProvideTheExpectedIdentifier() {
        simulateEventsChanged()
        let viewModel = context.makeViewModel()

        let randomEventInGroupOne = expectedGroups[0].events.randomElement()
        let indexPath = IndexPath(item: randomEventInGroupOne.index, section: 0)
        let expected = randomEventInGroupOne.element.identifier
        let actual = viewModel?.identifierForEvent(at: indexPath)

        XCTAssertEqual(expected, actual)
    }

}
