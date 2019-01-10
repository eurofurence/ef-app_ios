//
//  DefaultNewsInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

private protocol NewsViewModelComponent {

    var childCount: Int { get }
    var title: String { get }

    func announceContent(at index: Int, to visitor: NewsViewModelVisitor)
    func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void)

}

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
        self.init(announcementsService: SharedModel.instance.services.announcements,
                  authenticationService: SharedModel.instance.services.authentication,
                  privateMessagesService: SharedModel.instance.services.privateMessages,
                  daysUntilConventionService: SharedModel.instance.services.conventionCountdown,
                  eventsService: SharedModel.instance.services.events,
                  relativeTimeIntervalCountdownFormatter: FoundationRelativeTimeIntervalCountdownFormatter.shared,
                  hoursDateFormatter: FoundationHoursDateFormatter.shared,
                  dateDistanceCalculator: FoundationDateDistanceCalculator(),
                  clock: SystemClock.shared,
                  refreshService: SharedModel.instance.services.refresh,
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

    func eurofurenceApplicationDidChangeAnnouncements(_ announcements: [Announcement]) {
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

    // MARK: PrivateMessagesServiceObserver

    func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int) {
        unreadMessagesCount = unreadCount
        regenerateViewModel()
    }

    func privateMessagesServiceDidFinishRefreshingMessages(messages: [APIMessage]) {

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
        components.append(UserComponent(viewModel: userWidgetViewModel))

        if let daysUntilConvention = daysUntilConvention {
            components.append(CountdownComponent(daysUntilConvention: daysUntilConvention))
        }

		components.append(AnnouncementsComponent(announcements: announcements, readAnnouncements: readAnnouncements, announcementsDateFormatter: announcementsDateFormatter, markdownRenderer: announcementsMarkdownRenderer))

        if !upcomingEvents.isEmpty {
            components.append(EventsComponent(title: .upcomingEvents,
                                              events: upcomingEvents,
                                              favouriteEventIdentifiers: favouriteEventIdentifiers,
                                              startTimeFormatter: { (event) -> String in
                                                let now = clock.currentDate
                                                let difference = event.startDate.timeIntervalSince1970 - now.timeIntervalSince1970
                                                return self.relativeTimeIntervalCountdownFormatter.relativeString(from: difference)
            }, hoursDateFormatter: hoursDateFormatter))
        }

        if !runningEvents.isEmpty {
            components.append(EventsComponent(title: .runningEvents,
                                              events: runningEvents,
                                              favouriteEventIdentifiers: favouriteEventIdentifiers,
                                              startTimeFormatter: { (_) -> String in
                                                return .now
            }, hoursDateFormatter: hoursDateFormatter))
        }

        if !favouriteEvents.isEmpty {
            components.append(EventsComponent(title: .todaysFavouriteEvents,
                                              events: favouriteEvents,
                                              favouriteEventIdentifiers: favouriteEventIdentifiers,
                                              startTimeFormatter: { (event) -> String in
                                                return self.hoursDateFormatter.hoursString(from: event.startDate)
            }, hoursDateFormatter: hoursDateFormatter))
        }

        let viewModel = ViewModel(components: components)
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

    private struct UserComponent: NewsViewModelComponent {

        private let viewModel: UserWidgetComponentViewModel

        init(viewModel: UserWidgetComponentViewModel) {
            self.viewModel = viewModel
        }

        var childCount: Int { return 1 }
        var title: String { return .yourEurofurence }

        func announceContent(at index: Int, to visitor: NewsViewModelVisitor) {
            visitor.visit(viewModel)
        }

        func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void) {
            completionHandler(.messages)
        }

    }

    private struct CountdownComponent: NewsViewModelComponent {

        private let viewModel: ConventionCountdownComponentViewModel

        init(daysUntilConvention: Int) {
            let message = String.daysUntilConventionMessage(days: daysUntilConvention)
            viewModel = ConventionCountdownComponentViewModel(timeUntilConvention: message)
        }

        var childCount: Int {
            return 1
        }

        var title: String {
            return .daysUntilConvention
        }

        func announceContent(at index: Int, to visitor: NewsViewModelVisitor) {
            visitor.visit(viewModel)
        }

        func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void) {

        }

    }

    private struct AnnouncementsComponent: NewsViewModelComponent {

        private let announcements: [Announcement]
        private let viewModels: [AnnouncementComponentViewModel]

        init(announcements: [Announcement],
             readAnnouncements: [AnnouncementIdentifier],
             announcementsDateFormatter: AnnouncementDateFormatter,
			 markdownRenderer: MarkdownRenderer) {
            self.announcements = announcements
            viewModels = announcements.map({ (announcement) -> AnnouncementComponentViewModel in
                return AnnouncementComponentViewModel(title: announcement.title,
                                                      detail: markdownRenderer.render(announcement.content),
                                                      receivedDateTime: announcementsDateFormatter.string(from: announcement.date),
                                                      isRead: readAnnouncements.contains(announcement.identifier))
            })
        }

        var childCount: Int { return viewModels.count + 1 }
        var title: String { return .announcements }

        func announceContent(at index: Int, to visitor: NewsViewModelVisitor) {
            switch index {
            case 0:
                visitor.visit(ViewAllAnnouncementsComponentViewModel(caption: .allAnnouncements))

            default:
                let viewModel = viewModels[index - 1]
                visitor.visit(viewModel)
            }
        }

        func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void) {
            switch index {
            case 0:
                completionHandler(.allAnnouncements)

            default:
                let announcement = announcements[index - 1]
                completionHandler(.announcement(announcement.identifier))
            }
        }

    }

    private struct EventsComponent: NewsViewModelComponent {

        private let events: [Event]
        private let viewModels: [EventComponentViewModel]

        init(title: String,
             events: [Event],
             favouriteEventIdentifiers: [EventIdentifier],
             startTimeFormatter: (Event) -> String,
             hoursDateFormatter: HoursDateFormatter) {
            self.title = title
            self.events = events

            viewModels = events.map { (event) -> EventComponentViewModel in
                return EventComponentViewModel(startTime: startTimeFormatter(event),
                                               endTime: hoursDateFormatter.hoursString(from: event.endDate),
                                               eventName: event.title,
                                               location: event.room.name,
                                               isSponsorEvent: event.isSponsorOnly,
                                               isSuperSponsorEvent: event.isSuperSponsorOnly,
                                               isFavourite: favouriteEventIdentifiers.contains(event.identifier),
                                               isArtShowEvent: event.isArtShow,
                                               isKageEvent: event.isKageEvent,
                                               isDealersDenEvent: event.isDealersDen,
                                               isMainStageEvent: event.isMainStage,
                                               isPhotoshootEvent: event.isPhotoshoot)
            }
        }

        var title: String

        var childCount: Int {
            return viewModels.count
        }

        func announceContent(at index: Int, to visitor: NewsViewModelVisitor) {
            let viewModel = viewModels[index]
            visitor.visit(viewModel)
        }

        func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void) {
            let event = events[index]
            completionHandler(.event(event))
        }

    }

    private struct ViewModel: NewsViewModel {

        private let components: [NewsViewModelComponent]

        init(components: [NewsViewModelComponent]) {
            self.components = components
        }

        var numberOfComponents: Int {
            return components.count
        }

        func numberOfItemsInComponent(at index: Int) -> Int {
            return components[index].childCount
        }

        func titleForComponent(at index: Int) -> String {
            return components[index].title
        }

        func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
            let component = components[indexPath.section]
            component.announceContent(at: indexPath.item, to: visitor)
        }

        func fetchModelValue(at indexPath: IndexPath, completionHandler: @escaping (NewsViewModelValue) -> Void) {
            components[indexPath.section].announceValue(at: indexPath.item, to: completionHandler)
        }

    }

}
