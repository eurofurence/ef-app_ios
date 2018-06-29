//
//  DefaultNewsInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

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
                             PrivateMessagesServiceObserver,
                             ConventionCountdownServiceObserver,
                             EventsServiceObserver,
                             RefreshServiceObserver {

    // MARK: Properties

    private let relativeTimeIntervalCountdownFormatter: RelativeTimeIntervalCountdownFormatter
    private let hoursDateFormatter: HoursDateFormatter
    private var delegate: NewsInteractorDelegate?
    private var unreadMessagesCount = 0
    private var daysUntilConvention: Int?
    private var runningEvents = [Event2]()
    private var upcomingEvents = [Event2]()
    private var announcements = [Announcement2]()
    private var currentUser: User?
    private let dateDistanceCalculator: DateDistanceCalculator
    private let clock: Clock
    private let refreshService: RefreshService

    // MARK: Initialization

    convenience init() {
        self.init(announcementsService: EurofurenceApplication.shared,
                  authenticationService: EurofurenceApplication.shared,
                  privateMessagesService: EurofurencePrivateMessagesService.shared,
                  daysUntilConventionService: EurofurenceApplication.shared,
                  eventsService: EurofurenceApplication.shared,
                  relativeTimeIntervalCountdownFormatter: FoundationRelativeTimeIntervalCountdownFormatter.shared,
                  hoursDateFormatter: FoundationHoursDateFormatter.shared,
                  dateDistanceCalculator: FoundationDateDistanceCalculator(),
                  clock: SystemClock(),
                  refreshService: EurofurenceApplication.shared)
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
         refreshService: RefreshService) {
        self.relativeTimeIntervalCountdownFormatter = relativeTimeIntervalCountdownFormatter
        self.hoursDateFormatter = hoursDateFormatter
        self.dateDistanceCalculator = dateDistanceCalculator
        self.clock = clock
        self.refreshService = refreshService

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
        refreshService.performRefresh()
    }

    // MARK: AnnouncementsServiceObserver

    func eurofurenceApplicationDidChangeAnnouncements(_ announcements: [Announcement2]) {

    }

    func eurofurenceApplicationDidChangeUnreadAnnouncements(to announcements: [Announcement2]) {
        self.announcements = announcements
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

    func privateMessagesServiceDidFinishRefreshingMessages(_ messages: [Message]) {

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

    private var allEvents = [Event2]()
    private var favouriteEvents = [Event2]()
    private var favouriteEventIdentifiers = [Event2.Identifier]()
    func eventsDidChange(to events: [Event2]) {
        allEvents = events
        regenerateFavouriteEvents()
    }

    func runningEventsDidChange(to events: [Event2]) {
        runningEvents = events
        regenerateViewModel()
    }

    func upcomingEventsDidChange(to events: [Event2]) {
        upcomingEvents = events
        regenerateViewModel()
    }

    func favouriteEventsDidChange(_ identifiers: [Event2.Identifier]) {
        favouriteEventIdentifiers = identifiers
        regenerateFavouriteEvents()
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
        favouriteEvents = allEvents.filter({ favouriteEventIdentifiers.contains($0.identifier) })
        regenerateViewModel()
    }

    private func regenerateViewModel() {
        let userWidgetViewModel = makeUserWidgetViewModel()
        var components = [NewsViewModelComponent]()
        components.append(UserComponent(viewModel: userWidgetViewModel))

        if let daysUntilConvention = daysUntilConvention {
            components.append(CountdownComponent(daysUntilConvention: daysUntilConvention))
        }

        components.append(AnnouncementsComponent(announcements: announcements))

        if !upcomingEvents.isEmpty {
            components.append(EventsComponent(title: .upcomingEvents,
                                              events: upcomingEvents,
                                              startTimeFormatter: { (event) -> String in
                                                let now = clock.currentDate
                                                let difference = event.startDate.timeIntervalSince1970 - now.timeIntervalSince1970
                                                return self.relativeTimeIntervalCountdownFormatter.relativeString(from: difference)
            }, hoursDateFormatter: hoursDateFormatter))
        }

        if !runningEvents.isEmpty {
            components.append(EventsComponent(title: .runningEvents,
                                              events: runningEvents,
                                              startTimeFormatter: { (_) -> String in
                                                return .now
            }, hoursDateFormatter: hoursDateFormatter))
        }

        if !favouriteEvents.isEmpty {
            components.append(EventsComponent(title: .favouriteEvents,
                                              events: favouriteEvents,
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

        private let announcements: [Announcement2]
        private let viewModels: [AnnouncementComponentViewModel]

        init(announcements: [Announcement2]) {
            self.announcements = announcements
            viewModels = announcements.map({ (announcement) -> AnnouncementComponentViewModel in
                return AnnouncementComponentViewModel(title: announcement.title, detail: announcement.content)
            })
        }

        var childCount: Int { return viewModels.count }
        var title: String { return .announcements }

        func announceContent(at index: Int, to visitor: NewsViewModelVisitor) {
            let viewModel = viewModels[index]
            visitor.visit(viewModel)
        }

        func announceValue(at index: Int, to completionHandler: @escaping (NewsViewModelValue) -> Void) {
            let announcement = announcements[index]
            completionHandler(.announcement(announcement))
        }

    }

    private struct EventsComponent: NewsViewModelComponent {

        private let events: [Event2]
        private let viewModels: [EventComponentViewModel]

        init(title: String,
             events: [Event2],
             startTimeFormatter: (Event2) -> String,
             hoursDateFormatter: HoursDateFormatter) {
            self.title = title
            self.events = events

            viewModels = events.map { (event) -> EventComponentViewModel in
                return EventComponentViewModel(startTime: startTimeFormatter(event),
                                               endTime: hoursDateFormatter.hoursString(from: event.endDate),
                                               eventName: event.title,
                                               location: event.room.name,
                                               icon: nil)
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
