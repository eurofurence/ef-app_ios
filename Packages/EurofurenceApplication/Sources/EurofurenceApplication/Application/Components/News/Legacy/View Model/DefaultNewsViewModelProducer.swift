import ComponentBase
import EurofurenceModel
import Foundation

public class DefaultNewsViewModelProducer: NewsViewModelProducer,
                                           AnnouncementsRepositoryObserver,
                                           AuthenticationStateObserver,
                                           PrivateMessagesObserver,
                                           ConventionCountdownServiceObserver,
                                           ScheduleRepositoryObserver,
                                           RefreshServiceObserver {

    // MARK: Properties

    private let relativeTimeIntervalCountdownFormatter: RelativeTimeIntervalCountdownFormatter
    private let hoursDateFormatter: HoursDateFormatter
    private var delegate: NewsViewModelRecipient?
    private var unreadMessagesCount = 0
    private var daysUntilConvention: Int?
    private var runningEvents = [Event]()
    private var upcomingEvents = [Event]()
    private var announcements = [Announcement]()
    private var readAnnouncements = [AnnouncementIdentifier]()
    private var currentUser: User?
    private let clock: Clock
    private let refreshService: RefreshService
    private let favouritesSchedule: Schedule
    private var todaysFavouriteEvents = [Event]()
    private var currentDay: Day?
    private let announcementsDateFormatter: AnnouncementDateFormatter
	private let announcementsMarkdownRenderer: MarkdownRenderer

    // MARK: Initialization

    public init(
        announcementsService: AnnouncementsRepository,
        authenticationService: AuthenticationService,
        privateMessagesService: PrivateMessagesService,
        daysUntilConventionService: ConventionCountdownService,
        eventsService: ScheduleRepository,
        relativeTimeIntervalCountdownFormatter: RelativeTimeIntervalCountdownFormatter,
        hoursDateFormatter: HoursDateFormatter,
        clock: Clock,
        refreshService: RefreshService,
        announcementsDateFormatter: AnnouncementDateFormatter,
        announcementsMarkdownRenderer: MarkdownRenderer
    ) {
        self.relativeTimeIntervalCountdownFormatter = relativeTimeIntervalCountdownFormatter
        self.hoursDateFormatter = hoursDateFormatter
        self.clock = clock
        self.refreshService = refreshService
        self.announcementsDateFormatter = announcementsDateFormatter
		self.announcementsMarkdownRenderer = announcementsMarkdownRenderer
        favouritesSchedule = eventsService.loadSchedule(tag: "News Favourites")
        favouritesSchedule.setDelegate(UpdateViewModelWhenFavouritesScheduleChanges(viewModel: self))

        announcementsService.add(self)
        authenticationService.add(self)
        privateMessagesService.add(self)
        daysUntilConventionService.add(self)
        eventsService.add(self)
        refreshService.add(self)
    }
    
    private struct UpdateViewModelWhenFavouritesScheduleChanges: ScheduleDelegate {
        
        unowned let viewModel: DefaultNewsViewModelProducer
        
        func scheduleEventsDidChange(to events: [Event]) {
            viewModel.todaysFavouriteEvents = events
            viewModel.regenerateViewModel()
        }
        
        func eventDaysDidChange(to days: [Day]) {
            
        }
        
        func currentEventDayDidChange(to day: Day?) {
            viewModel.currentDay = day
            if let day = day {
                viewModel.favouritesSchedule.restrictEvents(to: day)
            }
        }
        
    }

    // MARK: NewsViewModelProducer

    public func subscribeViewModelUpdates(_ delegate: NewsViewModelRecipient) {
        self.delegate = delegate
        regenerateViewModel()
    }

    public func refresh() {
        refreshService.refreshLocalStore { (_) in }
    }

    // MARK: AnnouncementsRepositoryObserver

    public func announcementsServiceDidChangeAnnouncements(_ announcements: [Announcement]) {
        self.announcements = Array(announcements.prefix(3))
        regenerateViewModel()
    }

    public func announcementsServiceDidUpdateReadAnnouncements(_ readAnnouncements: [AnnouncementIdentifier]) {
        self.readAnnouncements = readAnnouncements
        regenerateViewModel()
    }

    // MARK: AuthenticationStateObserver

    public func userAuthenticated(_ user: User) {
        currentUser = user
        regenerateViewModel()
    }

    public func userUnauthenticated() {
        currentUser = nil
        regenerateViewModel()
    }

    // MARK: PrivateMessagesServiceObserver

    public func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int) {
        unreadMessagesCount = unreadCount
        regenerateViewModel()
    }

    public func privateMessagesServiceDidFinishRefreshingMessages(messages: [Message]) {

    }

    public func privateMessagesServiceDidFailToLoadMessages() {

    }

    // MARK: DaysUntilConventionServiceObserver

    public func conventionCountdownStateDidChange(to state: ConventionCountdownState) {
        switch state {
        case .countingDown(let daysRemaining):
            daysUntilConvention = daysRemaining

        case .countdownElapsed:
            daysUntilConvention = nil
        }

        regenerateViewModel()
    }

    // MARK: ScheduleRepositoryObserver

    private var favouriteEvents = [Event]()
    private var favouriteEventIdentifiers = [EventIdentifier]()
    
    public func eventsDidChange(to events: [Event]) {
        
    }

    public func runningEventsDidChange(to events: [Event]) {
        runningEvents = events
        regenerateViewModel()
    }

    public func upcomingEventsDidChange(to events: [Event]) {
        upcomingEvents = events
        regenerateViewModel()
    }

    public func favouriteEventsDidChange(_ identifiers: [EventIdentifier]) {
        favouriteEventIdentifiers = identifiers
        regenerateFavouriteEvents()
    }
    
    // MARK: RefreshServiceObserver

    public func refreshServiceDidBeginRefreshing() {
        delegate?.refreshDidBegin()
    }

    public func refreshServiceDidFinishRefreshing() {
        delegate?.refreshDidFinish()
    }

    // MARK: Private

    private func regenerateFavouriteEvents() {
        if currentDay == nil {
            favouriteEvents = []
        } else {
            favouriteEvents = todaysFavouriteEvents.filter({ favouriteEventIdentifiers.contains($0.identifier) })
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
            components.append(
                NewsViewModelEventsComponent(
                    title: .upcomingEvents,
                    events: upcomingEvents,
                    favouriteEventIdentifiers: favouriteEventIdentifiers,
                    startTimeFormatter: { (event) -> String in
                        let now = clock.currentDate
                        let difference = event.startDate.timeIntervalSince1970 - now.timeIntervalSince1970
                        return self.relativeTimeIntervalCountdownFormatter.relativeString(from: difference)
                    },
                    hoursDateFormatter: hoursDateFormatter
                )
            )
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
