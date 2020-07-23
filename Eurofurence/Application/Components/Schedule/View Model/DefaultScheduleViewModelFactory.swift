import EurofurenceModel
import Foundation

public class DefaultScheduleViewModelFactory: ScheduleViewModelFactory, EventsServiceObserver {

    // MARK: Properties

    private let viewModel: ViewModel
    private let searchViewModel: SearchViewModel

    // MARK: Initialization

    public init(
        eventsService: EventsService,
        hoursDateFormatter: HoursDateFormatter,
        shortFormDateFormatter: ShortFormDateFormatter,
        shortFormDayAndTimeFormatter: ShortFormDayAndTimeFormatter,
        refreshService: RefreshService,
        shareService: ShareService
    ) {
        let schedule = eventsService.makeEventsSchedule()
        let searchController = eventsService.makeEventsSearchController()
        
        viewModel = ViewModel(
            schedule: schedule,
            eventsService: eventsService,
            hoursDateFormatter: hoursDateFormatter,
            shortFormDateFormatter: shortFormDateFormatter,
            refreshService: refreshService,
            shareService: shareService
        )
        
        searchViewModel = SearchViewModel(
            searchController: searchController,
            eventsService: eventsService,
            shortFormDayAndTimeFormatter: shortFormDayAndTimeFormatter,
            hoursDateFormatter: hoursDateFormatter,
            shareService: shareService
        )

        eventsService.add(self)
    }

    // MARK: ScheduleViewModelFactory

    public func makeViewModel(completionHandler: @escaping (ScheduleViewModel) -> Void) {
        completionHandler(viewModel)
    }

    public func makeSearchViewModel(completionHandler: @escaping (ScheduleSearchViewModel) -> Void) {
        completionHandler(searchViewModel)
    }

    // MARK: EventsServiceObserver

    public func favouriteEventsDidChange(_ identifiers: [EventIdentifier]) {
        viewModel.favouriteEventsDidChange(identifiers)
        searchViewModel.favouriteEventsDidChange(identifiers)
    }

    public func eventsDidChange(to events: [Event]) {}
    public func runningEventsDidChange(to events: [Event]) {}
    public func upcomingEventsDidChange(to events: [Event]) {}

    // MARK: Private

    private struct EventsGroupedByDate {
        var date: Date
        var events: [Event]

        func compare(against: EventsGroupedByDate) -> Bool {
            return date < against.date
        }
    }

    private class ViewModel: ScheduleViewModel, EventsScheduleDelegate, RefreshServiceObserver {

        private var delegate: ScheduleViewModelDelegate?
        private var rawModelGroups = [EventsGroupedByDate]()

        private var days = [Day]()
        var dayViewModels: [ScheduleDayViewModel] = [] {
            didSet {
                delegate?.scheduleViewModelDidUpdateDays(dayViewModels)
            }
        }

        var eventGroupViewModels: [ScheduleEventGroupViewModel] = [] {
            willSet {
                eventGroupViewModels
                    .flatMap({ $0.events })
                    .compactMap({ $0 as? EventViewModel })
                    .forEach({ $0.unhookFromEventObservation() })
            }
            didSet {
                delegate?.scheduleViewModelDidUpdateEvents(eventGroupViewModels)
            }
        }

        private let schedule: EventsSchedule
        private let eventsService: EventsService
        private let hoursDateFormatter: HoursDateFormatter
        private let shortFormDateFormatter: ShortFormDateFormatter
        private let refreshService: RefreshService
        private let shareService: ShareService
        private var events = [Event]()
        private var favouriteEvents = [EventIdentifier]()

        init(
            schedule: EventsSchedule,
            eventsService: EventsService,
            hoursDateFormatter: HoursDateFormatter,
            shortFormDateFormatter: ShortFormDateFormatter,
            refreshService: RefreshService,
            shareService: ShareService
        ) {
            self.schedule = schedule
            self.eventsService = eventsService
            self.hoursDateFormatter = hoursDateFormatter
            self.shortFormDateFormatter = shortFormDateFormatter
            self.refreshService = refreshService
            self.shareService = shareService

            refreshService.add(self)
            schedule.setDelegate(self)
        }

        var selectedDayIndex = 0

        fileprivate func regenerateEventViewModels() {
            let groupedByDate = Dictionary(grouping: events, by: { $0.startDate })
            rawModelGroups = groupedByDate.map(EventsGroupedByDate.init).sorted(by: { (first, second) -> Bool in
                return first.compare(against: second)
            })

            eventGroupViewModels = rawModelGroups.map { (group) -> ScheduleEventGroupViewModel in
                let title = hoursDateFormatter.hoursString(from: group.date)
                let viewModels = group.events.map { (event) -> EventViewModel in
                    return EventViewModel(event: event, hoursFormatter: hoursDateFormatter, shareService: shareService)
                }

                return ScheduleEventGroupViewModel(title: title, events: viewModels)
            }
        }

        func scheduleEventsDidChange(to events: [Event]) {
            self.events = events
            regenerateEventViewModels()
        }

        func eventDaysDidChange(to days: [Day]) {
            self.days = days
            self.dayViewModels = days.map { (day) -> ScheduleDayViewModel in
                return ScheduleDayViewModel(title: shortFormDateFormatter.dateString(from: day.date))
            }
        }

        func currentEventDayDidChange(to day: Day?) {
            guard let day = day else { return }
            schedule.restrictEvents(to: day)

            guard let idx = days.firstIndex(where: { $0.date == day.date }) else { return }
            selectedDayIndex = idx
        }

        func setDelegate(_ delegate: ScheduleViewModelDelegate) {
            self.delegate = delegate

            delegate.scheduleViewModelDidUpdateDays(dayViewModels)
            delegate.scheduleViewModelDidUpdateEvents(eventGroupViewModels)
            delegate.scheduleViewModelDidUpdateCurrentDayIndex(to: selectedDayIndex)
        }

        func refresh() {
            refreshService.refreshLocalStore { (_) in }
        }

        func showEventsForDay(at index: Int) {
            let day = days[index]
            schedule.restrictEvents(to: day)
        }

        func identifierForEvent(at indexPath: IndexPath) -> EventIdentifier? {
            return rawModelGroups[indexPath.section].events[indexPath.row].identifier
        }

        func refreshServiceDidBeginRefreshing() {
            delegate?.scheduleViewModelDidBeginRefreshing()
        }

        func refreshServiceDidFinishRefreshing() {
            delegate?.scheduleViewModelDidFinishRefreshing()
        }

        func favouriteEventsDidChange(_ identifiers: [EventIdentifier]) {
            
        }

    }

    private class SearchViewModel: ScheduleSearchViewModel, EventsSearchControllerDelegate {

        private let searchController: EventsSearchController
        private let eventsService: EventsService
        private let shortFormDayAndTimeFormatter: ShortFormDayAndTimeFormatter
        private let hoursDateFormatter: HoursDateFormatter
        private let shareService: ShareService
        private var rawModelGroups = [EventsGroupedByDate]()
        private var searchResults = [Event]()
        private var favouriteEvents = [EventIdentifier]()

        init(
            searchController: EventsSearchController,
            eventsService: EventsService,
            shortFormDayAndTimeFormatter: ShortFormDayAndTimeFormatter,
            hoursDateFormatter: HoursDateFormatter,
            shareService: ShareService
        ) {
            self.eventsService = eventsService
            self.searchController = searchController
            self.hoursDateFormatter = hoursDateFormatter
            self.shortFormDayAndTimeFormatter = shortFormDayAndTimeFormatter
            self.shareService = shareService

            searchController.setResultsDelegate(self)
        }

        private var delegate: ScheduleSearchViewModelDelegate?
        func setDelegate(_ delegate: ScheduleSearchViewModelDelegate) {
            self.delegate = delegate
        }

        func updateSearchResults(input: String) {
            searchController.changeSearchTerm(input)
        }

        func identifierForEvent(at indexPath: IndexPath) -> EventIdentifier? {
            return rawModelGroups[indexPath.section].events[indexPath.row].identifier
        }

        func filterToFavourites() {
            searchController.restrictResultsToFavourites()
        }

        func filterToAllEvents() {
            searchController.removeFavouritesEventsRestriction()
        }

        func searchResultsDidUpdate(to results: [Event]) {
            searchResults = results
            regenerateViewModel()
        }

        func favouriteEventsDidChange(_ identifiers: [EventIdentifier]) {
            
        }

        private func regenerateViewModel() {
            let groupedByDate = Dictionary(grouping: searchResults, by: { $0.startDate })
            rawModelGroups = groupedByDate.map(EventsGroupedByDate.init).sorted(by: { (first, second) -> Bool in
                return first.compare(against: second)
            })

            let eventGroupViewModels = rawModelGroups.map(makeScheduleGroupViewModel)

            delegate?.scheduleSearchResultsUpdated(eventGroupViewModels)
        }

        private func makeScheduleGroupViewModel(_ group: EventsGroupedByDate) -> ScheduleEventGroupViewModel {
            let title = shortFormDayAndTimeFormatter.dayAndHoursString(from: group.date)
            let viewModels = group.events.map(makeEventViewModel)

            return ScheduleEventGroupViewModel(title: title, events: viewModels)
        }

        private func makeEventViewModel(_ event: Event) -> EventViewModel {
            return EventViewModel(event: event, hoursFormatter: hoursDateFormatter, shareService: shareService)
        }

    }

    private class EventViewModel: ScheduleEventViewModelProtocol, EventObserver {
        
        private let event: Event
        private let hoursFormatter: HoursDateFormatter
        private let shareService: ShareService
        
        init(event: Event, hoursFormatter: HoursDateFormatter, shareService: ShareService) {
            self.event = event
            self.hoursFormatter = hoursFormatter
            self.shareService = shareService
            
            title = event.title
            startTime = hoursFormatter.hoursString(from: event.startDate)
            endTime = hoursFormatter.hoursString(from: event.endDate)
            location = event.room.name
            bannerGraphicPNGData = event.bannerGraphicPNGData
            isFavourite = false
            isSponsorOnly = event.isSponsorOnly
            isSuperSponsorOnly = event.isSuperSponsorOnly
            isArtShow = event.isArtShow
            isKageEvent = event.isKageEvent
            isDealersDenEvent = event.isDealersDen
            isMainStageEvent = event.isMainStage
            isPhotoshootEvent = event.isPhotoshoot
            isAcceptingFeedback = false
            
            event.add(self)
        }

        var title: String
        var startTime: String
        var endTime: String
        var location: String
        var bannerGraphicPNGData: Data?
        var isFavourite: Bool
        var isSponsorOnly: Bool
        var isSuperSponsorOnly: Bool
        var isArtShow: Bool
        var isKageEvent: Bool
        var isDealersDenEvent: Bool
        var isMainStageEvent: Bool
        var isPhotoshootEvent: Bool
        var isAcceptingFeedback: Bool
        
        private weak var observer: ScheduleEventViewModelObserver?
        
        func add(_ observer: ScheduleEventViewModelObserver) {
            self.observer = observer
        }
        
        func favourite() {
            event.favourite()
        }
        
        func unfavourite() {
            event.unfavourite()
        }
        
        func share(_ sender: Any) {
            let eventURL = event.makeContentURL()
            shareService.share(eventURL, sender: sender)
        }
        
        func eventDidBecomeFavourite(_ event: Event) {
            isFavourite = true
            observer?.eventViewModelDidBecomeFavourite(self)
        }
        
        func eventDidBecomeUnfavourite(_ event: Event) {
            isFavourite = false
            observer?.eventViewModelDidBecomeNonFavourite(self)
        }
        
        func unhookFromEventObservation() {
            event.remove(self)
        }

    }

}
