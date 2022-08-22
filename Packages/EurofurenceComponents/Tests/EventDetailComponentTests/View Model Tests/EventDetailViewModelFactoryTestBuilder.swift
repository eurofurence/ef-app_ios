import EurofurenceModel
import EventDetailComponent
import XCTComponentBase
import XCTEurofurenceModel

class EventDetailViewModelFactoryTestBuilder {

    struct Context {
        var event: Event
        var dateRangeFormatter: FakeDateRangeFormatter
        var viewModelFactory: DefaultEventDetailViewModelFactory
        var viewModel: EventDetailViewModel
        var eventsService: FakeScheduleRepository
		var markdownRenderer: StubMarkdownRenderer
        var shareService: CapturingShareService
        var calendarEventRepository: FakeCalendarEventRepository
    }

    private var eventsService: FakeScheduleRepository

    init() {
        eventsService = FakeScheduleRepository()
    }

    @discardableResult
    func with(_ eventsService: FakeScheduleRepository) -> EventDetailViewModelFactoryTestBuilder {
        self.eventsService = eventsService
        return self
    }

    func build(for event: Event = FakeEvent.randomStandardEvent) -> Context {
        let dateRangeFormatter = FakeDateRangeFormatter()
		let markdownRenderer = StubMarkdownRenderer()
        eventsService.allEvents = [event]
        let shareService = CapturingShareService()
        let calendarEventRepository = FakeCalendarEventRepository()
        let viewModelFactory = DefaultEventDetailViewModelFactory(
            dateRangeFormatter: dateRangeFormatter,
            eventsService: eventsService,
            markdownRenderer: markdownRenderer,
            shareService: shareService,
            calendarRepository: calendarEventRepository
        )
        
        var viewModel: EventDetailViewModel!
        viewModelFactory.makeViewModel(for: event.identifier) { viewModel = $0 }
        
        assert(viewModel != nil)

        return Context(
            event: event,
            dateRangeFormatter: dateRangeFormatter,
            viewModelFactory: viewModelFactory,
            viewModel: viewModel,
            eventsService: eventsService,
            markdownRenderer: markdownRenderer,
            shareService: shareService,
            calendarEventRepository: calendarEventRepository
        )
    }

}

extension EventDetailViewModelFactoryTestBuilder.Context {

    func makeExpectedEventSummaryViewModel() -> EventSummaryViewModel {
        EventSummaryViewModel(
            title: event.title,
            subtitle: event.subtitle,
            abstract: markdownRenderer.stubbedContents(for: event.abstract),
            eventStartEndTime: dateRangeFormatter.string(from: event.startDate, to: event.endDate),
            location: event.room.name,
            trackName: event.track.name,
            eventHosts: event.hosts
        )
    }
    
    func makeExpectedEventGraphicViewModel() -> EventGraphicViewModel {
        guard let data = event.posterGraphicPNGData ?? event.bannerGraphicPNGData else {
            fatalError("Event used in test isn't stubbed with image data")
        }

        return EventGraphicViewModel(pngGraphicData: data)
    }

    func makeExpectedEventDescriptionViewModel() -> EventDescriptionViewModel {
        return EventDescriptionViewModel(contents: markdownRenderer.stubbedContents(for: event.eventDescription))
    }
    
    func prepareVisitorForTesting() -> CapturingEventDetailViewModelVisitor {
        let visitor = CapturingEventDetailViewModelVisitor()
        visitor.consume(contentsOf: viewModel)
        
        return visitor
    }

}
