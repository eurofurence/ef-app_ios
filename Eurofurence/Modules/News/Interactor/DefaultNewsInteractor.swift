import EurofurenceModel
import Foundation

class DefaultNewsInteractor: NewsInteractor,
                             AnnouncementsServiceObserver,
                             AuthenticationStateObserver,
                             PrivateMessagesObserver,
                             ConventionCountdownServiceObserver,
                             EventsServiceObserver,
                             RefreshServiceObserver,
                             EventsScheduleDelegate {

    // MARK: Properties

    private let relativeTimeIntervalCountdownFormatter: RelativeTimeIntervalCountdownFormatter
    private let hoursDateFormatter: HoursDateFormatter
    private var delegate: NewsInteractorDelegate?
    private var unreadMessagesCount = 0
    private var daysUntilConvention: Int?
    private var runningEvents = [Event]()
    private var upcomingEvents = [Event]()
    private var announcements = [Announcement]()
    private var readAnnouncements = [AnnouncementIdentifier]()
    private var currentUser: User?
    private let dateDistanceCalculator: DateDistanceCalculator
    private let clock: Clock
    private let refreshService: RefreshService
    private let favouritesSchedule: EventsSchedule
    private var todaysEvents = [Event]()
    private var currentDay: Day?
    private let announcementsDateFormatter: AnnouncementDateFormatter
	private let announcementsMarkdownRenderer: MarkdownRenderer

    // MARK: Initialization

    convenience init() {
        self.init(announcementsService: ApplicationStack.instance.services.announcements,
                  authenticationService: ApplicationStack.instance.services.authentication,
                  privateMessagesService: ApplicationStack.instance.services.privateMessages,
                  daysUntilConventionService: ApplicationStack.instance.services.conventionCountdown,
                  eventsService: ApplicationStack.instance.services.events,
                  relativeTimeIntervalCountdownFormatter: FoundationRelativeTimeIntervalCountdownFormatter.shared,
                  hoursDateFormatter: FoundationHoursDateFormatter.shared,
                  dateDistanceCalculator: FoundationDateDistanceCalculator(),
                  clock: SystemClock.shared,
                  refreshService: ApplicationStack.instance.services.refresh,
                  announcementsDateFormatter: FoundationAnnouncementDateFormatter.shared,
				  announcementsMarkdownRenderer: SubtleDownMarkdownRenderer())
    }

    init(announcementsService: AnnouncementsService,
         authenticationService: AuthenticationService,
         privateMessagesService: PrivateMessagesService,
         daysUntilConventionService: ConventionCountdownService,
         eventsService: EventsService,
         relativeTimeIntervalCountdownFormatter: RelativeTimeIntervalCountdownFormatter,
         hoursDateFormatter: HoursDateFormatter,
         dateDistanceCalculator: DateDistanceCalculator,
         clock: Clock,
         refreshService: RefreshService,
         announcementsDateFormatter: AnnouncementDateFormatter,
         announcementsMarkdownRenderer: MarkdownRenderer) {
        self.relativeTimeIntervalCountdownFormatter = relativeTimeIntervalCountdownFormatter
        self.hoursDateFormatter = hoursDateFormatter
        self.dateDistanceCalculator = dateDistanceCalculator
        self.clock = clock
        self.refreshService = refreshService
        self.announcementsDateFormatter = announcementsDateFormatter
		self.announcementsMarkdownRenderer = announcementsMarkdownRenderer
        favouritesSchedule = eventsService.makeEventsSchedule()
        favouritesSchedule.setDelegate(self)

        announcementsService.add(self)
        authenticationService.add(self)
        privateMessagesService.add(self)
        daysUntilConventionService.add(self)
        eventsService.add(self)
        refreshService.add(self)
    }

    // MARK: NewsInteractor

    func subscribeViewModelUpdates(_ delegate: NewsInteractorDelegate) {
        self.delegate = delegate
        regenerateViewModel()
    }

    func refresh() {
        refreshService.refreshLocalStore { (_) in }
    }

    // MARK: AnnouncementsServiceObserver

    func announcementsServiceDidChangeAnnouncements(_ announcements: [Announcement]) {
        self.announcements = Array(announcements.prefix(3))
        regenerateViewModel()
    }

    func announcementsServiceDidUpdateReadAnnouncements(_ readAnnouncements: [AnnouncementIdentifier]) {
        self.readAnnouncements = readAnnouncements
        regenerateViewModel()
    }

    // MARK: AuthenticationStateObserver

    func userDidLogin(_ user: User) {
        currentUser = user
        regenerateViewModel()
    }

    func userDidLogout() {
        currentUser = nil
        regenerateViewModel()
    }

    func userDidFailToLogout() {

    }

    // MARK: PrivateMessagesServiceObserver

    func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int) {
        unreadMessagesCount = unreadCount
        regenerateViewModel()
    }

    func privateMessagesServiceDidFinishRefreshingMessages(messages: [Message]) {

    }

    func privateMessagesServiceDidFailToLoadMessages() {

    }

    // MARK: DaysUntilConventionServiceObserver

    func conventionCountdownStateDidChange(to state: ConventionCountdownState) {
        switch state {
        case .countingDown(let daysRemaining):
            daysUntilConvention = daysRemaining

        case .countdownElapsed:
            daysUntilConvention = nil
        }

        regenerateViewModel()
    }

    // MARK: EventsServiceObserver

    private var allEvents = [Event]()
    private var favouriteEvents = [Event]()
    private var favouriteEventIdentifiers = [EventIdentifier]()
    func eventsDidChange(to events: [Event]) {
        allEvents = events
        regenerateFavouriteEvents()
    }

    func runningEventsDidChange(to events: [Event]) {
        runningEvents = events
        regenerateViewModel()
    }

    func upcomingEventsDidChange(to events: [Event]) {
        upcomingEvents = events
        regenerateViewModel()
    }

    func favouriteEventsDidChange(_ identifiers: [EventIdentifier]) {
        favouriteEventIdentifiers = identifiers
        regenerateFavouriteEvents()
    }

    // MARK: EventsScheduleDelegate

    func scheduleEventsDidChange(to events: [Event]) {
        todaysEvents = events
        regenerateViewModel()
    }

    func eventDaysDidChange(to days: [Day]) {

    }

    func currentEventDayDidChange(to day: Day?) {
        currentDay = day
        if let day = day {
            favouritesSchedule.restrictEvents(to: day)
        }
    }

    // MARK: RefreshServiceObserver

    func refreshServiceDidBeginRefreshing() {
        delegate?.refreshDidBegin()
    }

    func refreshServiceDidFinishRefreshing() {
        delegate?.refreshDidFinish()
    }

    // MARK: Private

    private func regenerateFavouriteEvents() {
        if currentDay == nil {
            favouriteEvents = []
        } else {
            favouriteEvents = todaysEvents.filter({ favouriteEventIdentifiers.contains($0.identifier) })
        }

        regenerateViewModel()
    }

    private func regenerateViewModel() {
        let userWidgetViewModel = makeUserWidgetViewModel()
        var components = [NewsViewModelComponent]()
        components.append(NewsViewModelUserComponent(viewModel: userWidgetViewModel))

        if let daysUntilConvention = daysUntilConvention {
            components.append(NewsViewModelCountdownComponent(daysUntilConvention: daysUntilConvention))
        }

        let announcementsComponent = NewsViewModelAnnouncementsComponent(announcements: announcements,
                                                            readAnnouncements: readAnnouncements,
                                                            announcementsDateFormatter: announcementsDateFormatter,
                                                            markdownRenderer: announcementsMarkdownRenderer)
        components.append(announcementsComponent)

        if !upcomingEvents.isEmpty {
            components.append(NewsViewModelEventsComponent(title: .upcomingEvents,
                                              events: upcomingEvents,
                                              favouriteEventIdentifiers: favouriteEventIdentifiers,
                                              startTimeFormatter: { (event) -> String in
                                                let now = clock.currentDate
                                                let difference = event.startDate.timeIntervalSince1970 - now.timeIntervalSince1970
                                                return self.relativeTimeIntervalCountdownFormatter.relativeString(from: difference)
            }, hoursDateFormatter: hoursDateFormatter))
        }

        if !runningEvents.isEmpty {
            components.append(NewsViewModelEventsComponent(title: .runningEvents,
                                              events: runningEvents,
                                              favouriteEventIdentifiers: favouriteEventIdentifiers,
                                              startTimeFormatter: { (_) -> String in
                                                return .now
            }, hoursDateFormatter: hoursDateFormatter))
        }

        if !favouriteEvents.isEmpty {
            components.append(NewsViewModelEventsComponent(title: .todaysFavouriteEvents,
                                              events: favouriteEvents,
                                              favouriteEventIdentifiers: favouriteEventIdentifiers,
                                              startTimeFormatter: { (event) -> String in
                                                return self.hoursDateFormatter.hoursString(from: event.startDate)
            }, hoursDateFormatter: hoursDateFormatter))
        }

        let viewModel = DefaultNewsViewModel(components: components)
        delegate?.viewModelDidUpdate(viewModel)
    }

    private func makeUserWidgetViewModel() -> UserWidgetComponentViewModel {
        if let user = currentUser {
            return UserWidgetComponentViewModel(prompt: .welcomePrompt(for: user),
                                                detailedPrompt: .welcomeDescription(messageCount: unreadMessagesCount),
                                                hasUnreadMessages: unreadMessagesCount > 0)
        } else {
            return UserWidgetComponentViewModel(prompt: .anonymousUserLoginPrompt,
                                                detailedPrompt: .anonymousUserLoginDescription,
                                                hasUnreadMessages: false)
        }
    }

}
