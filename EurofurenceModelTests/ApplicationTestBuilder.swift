//
//  ApplicationTestBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class ApplicationTestBuilder {

    struct Context {
        var application: EurofurenceSession
        var clock: StubClock
        var capturingTokenRegistration: CapturingRemoteNotificationsTokenRegistration
        var capturingCredentialStore: CapturingCredentialStore
        var loginAPI: CapturingLoginAPI
        var privateMessagesAPI: CapturingPrivateMessagesAPI
        var syncAPI: CapturingSyncAPI
        var dataStore: CapturingEurofurenceDataStore
        var dateDistanceCalculator: StubDateDistanceCalculator
        var conventionStartDateRepository: StubConventionStartDateRepository
        var imageAPI: FakeImageAPI
        var imageRepository: CapturingImageRepository
        var significantTimeChangeAdapter: CapturingSignificantTimeChangeAdapter
        var urlOpener: CapturingURLOpener
        var longRunningTaskManager: FakeLongRunningTaskManager
        var notificationScheduler: CapturingNotificationScheduler
        var hoursDateFormatter: FakeHoursDateFormatter
        var mapCoordinateRender: CapturingMapCoordinateRender

        var notificationsService: NotificationService {
            return application.services.notifications
        }

        var authenticationToken: String? {
            return capturingCredentialStore.persistedCredential?.authenticationToken
        }

        func tickTime(to time: Date) {
            clock.tickTime(to: time)
        }

        func registerForRemoteNotifications(_ deviceToken: Data = Data()) {
            notificationsService.storeRemoteNotificationsToken(deviceToken)
        }

        func login(registrationNumber: Int = 0,
                   username: String = "",
                   password: String = "",
                   completionHandler: @escaping (LoginResult) -> Void = { _ in }) {
            let arguments = LoginArguments(registrationNumber: registrationNumber, username: username, password: password)
            application.login(arguments, completionHandler: completionHandler)
        }

        func loginSuccessfully() {
            login()
            loginAPI.simulateResponse(LoginResponse(userIdentifier: .random, username: .random, token: .random, tokenValidUntil: Date(timeIntervalSinceNow: 1)))
        }

        @discardableResult
        func refreshLocalStore(completionHandler: ((Error?) -> Void)? = nil) -> Progress {
            return application.refreshLocalStore { (error) in
                completionHandler?(error)
            }
        }

        func performSuccessfulSync(response: APISyncResponse) {
            refreshLocalStore()
            syncAPI.simulateSuccessfulSync(response)
        }

        func expectedUnreadAnnouncements(from syncResponse: APISyncResponse) -> [Announcement] {
            // TODO: Needs to take into account any unread status information
            return expectedAnnouncements(from: syncResponse)
        }

        func expectedAnnouncements(from syncResponse: APISyncResponse) -> [Announcement] {
            return expectedAnnouncements(from: syncResponse.announcements.changed)
        }

        func expectedAnnouncements(from announcements: [APIAnnouncement]) -> [Announcement] {
            return Announcement.fromServerModels(announcements.sorted { (first, second) -> Bool in
                return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedDescending
            })
        }

        func expectedAnnouncement(from announcement: APIAnnouncement) -> Announcement {
            return Announcement(identifier: AnnouncementIdentifier(announcement.identifier),
                                 title: announcement.title,
                                 content: announcement.content,
                                 date: announcement.lastChangedDateTime)
        }

        func makeExpectedEvent(from event: APIEvent, response: APISyncResponse) -> Event {
            let expectedRoom = response.rooms.changed.first(where: { $0.roomIdentifier == event.roomIdentifier })!
            let expectedTrack = response.tracks.changed.first(where: { $0.trackIdentifier == event.trackIdentifier })!
            let expectedPosterGraphic = imageAPI.stubbedImage(for: event.posterImageId)
            let expectedBannerGraphic = imageAPI.stubbedImage(for: event.bannerImageId)
            let tags = event.tags.or([])

            return Event(identifier: EventIdentifier(event.identifier),
                          title: event.title,
                          subtitle: event.subtitle,
                          abstract: event.abstract,
                          room: Room(name: expectedRoom.name),
                          track: Track(name: expectedTrack.name),
                          hosts: event.panelHosts,
                          startDate: event.startDateTime,
                          endDate: event.endDateTime,
                          eventDescription: event.eventDescription,
                          posterGraphicPNGData: expectedPosterGraphic,
                          bannerGraphicPNGData: expectedBannerGraphic,
                          isSponsorOnly: tags.contains("sponsors_only"),
                          isSuperSponsorOnly: tags.contains("supersponsors_only"),
                          isArtShow: tags.contains("art_show"),
                          isKageEvent: tags.contains("kage"),
                          isDealersDen: tags.contains("dealers_den"),
                          isMainStage: tags.contains("main_stage"),
                          isPhotoshoot: tags.contains("photshoot"))
        }

        func makeExpectedEvents(from events: [APIEvent], response: APISyncResponse) -> [Event] {
            return events.map { makeExpectedEvent(from: $0, response: response) }
        }

        func makeExpectedDay(from day: APIConferenceDay) -> Day {
            return Day(date: day.date)
        }

        func makeExpectedDays(from response: APISyncResponse) -> [Day] {
            return response.conferenceDays.changed.map(makeExpectedDay).sorted(by: { $0.date < $1.date })
        }

        func makeExpectedDealer(from dealer: APIDealer) -> Dealer {
            return Dealer(identifier: DealerIdentifier(dealer.identifier),
                           preferredName: dealer.displayName,
                           alternateName: dealer.attendeeNickname == dealer.displayName ? nil : dealer.attendeeNickname,
                           isAttendingOnThursday: dealer.attendsOnThursday,
                           isAttendingOnFriday: dealer.attendsOnFriday,
                           isAttendingOnSaturday: dealer.attendsOnSaturday,
                           isAfterDark: dealer.isAfterDark)
        }

        func makeExpectedAlphabetisedDealers(from response: APISyncResponse) -> [AlphabetisedDealersGroup] {
            let dealers: [APIDealer] = response.dealers.changed
            let indexTitles = dealers.map({ String($0.displayName.first!) })
            var dealersByIndexBuckets = [String: [Dealer]]()
            for title in indexTitles {
                let dealersInBucket = dealers.filter({ $0.displayName.hasPrefix(title) })
                    .sorted(by: { $0.displayName < $1.displayName })
                    .map(makeExpectedDealer)
                dealersByIndexBuckets[title] = dealersInBucket
            }

            return dealersByIndexBuckets.sorted(by: { $0.key < $1.key }).map { (arg) -> AlphabetisedDealersGroup in
                let (title, dealers) = arg
                return AlphabetisedDealersGroup(indexingString: title, dealers: dealers)
            }
        }

        func makeExpectedMaps(from response: APISyncResponse) -> [Map] {
            return response.maps.changed.map({ (map) -> Map in
                return Map(identifier: MapIdentifier(map.identifier), location: map.mapDescription)
            }).sorted(by: { $0.location < $1.location })
        }

        func expectedKnowledgeGroups(from syncResponse: APISyncResponse) -> [KnowledgeGroup] {
            return syncResponse.knowledgeGroups.changed.map({ (group) -> KnowledgeGroup in
                return expectedKnowledgeGroup(from: group, syncResponse: syncResponse)
            }).sorted(by: { $0.order < $1.order })
        }

        func expectedKnowledgeGroup(from group: APIKnowledgeGroup, syncResponse: APISyncResponse) -> KnowledgeGroup {
            let entries = syncResponse.knowledgeEntries.changed.filter({ $0.groupIdentifier == group.identifier }).map { (entry) in
                return KnowledgeEntry(identifier: KnowledgeEntryIdentifier(entry.identifier),
                                       title: entry.title,
                                       order: entry.order,
                                       contents: entry.text,
                                       links: entry.links.map({ return Link(name: $0.name, type: Link.Kind(rawValue: $0.fragmentType.rawValue)!, contents: $0.target) }).sorted(by: { $0.name < $1.name }))
                }.sorted(by: { $0.order < $1.order })

            let addressString = group.fontAwesomeCharacterAddress
            let intValue = Int(addressString, radix: 16)!
            let unicodeScalar = UnicodeScalar(intValue)!
            let character = Character(unicodeScalar)

            return KnowledgeGroup(identifier: KnowledgeGroupIdentifier(group.identifier),
                                   title: group.groupName,
                                   groupDescription: group.groupDescription,
                                   fontAwesomeCharacterAddress: character,
                                   order: group.order,
                                   entries: entries)
        }

        func simulateSignificantTimeChange() {
            significantTimeChangeAdapter.simulateSignificantTimeChange()
        }

    }

    private let capturingTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
    private var capturingCredentialStore = CapturingCredentialStore()
    private var stubClock = StubClock()
    private let loginAPI = CapturingLoginAPI()
    private let privateMessagesAPI = CapturingPrivateMessagesAPI()
    private var pushPermissionsRequester: PushPermissionsRequester = CapturingPushPermissionsRequester()
    private var dataStore = CapturingEurofurenceDataStore()
    private var userPreferences: UserPreferences = StubUserPreferences()
    private let syncAPI = CapturingSyncAPI()
    private var timeIntervalForUpcomingEventsSinceNow: TimeInterval = .greatestFiniteMagnitude
    private var imageAPI: FakeImageAPI = FakeImageAPI()
    private var imageRepository = CapturingImageRepository()
    private var urlOpener: CapturingURLOpener = CapturingURLOpener()
    private var collectThemAllRequestFactory: CollectThemAllRequestFactory = StubCollectThemAllRequestFactory()
    private var forceUpgradeRequired: ForceRefreshRequired = StubForceRefreshRequired(isForceRefreshRequired: false)

    func with(_ currentDate: Date) -> ApplicationTestBuilder {
        stubClock = StubClock(currentDate: currentDate)
        return self
    }

    func with(_ persistedCredential: Credential?) -> ApplicationTestBuilder {
        capturingCredentialStore = CapturingCredentialStore(persistedCredential: persistedCredential)
        return self
    }

    func with(_ pushPermissionsRequester: PushPermissionsRequester) -> ApplicationTestBuilder {
        self.pushPermissionsRequester = pushPermissionsRequester
        return self
    }

    @discardableResult
    func with(_ dataStore: CapturingEurofurenceDataStore) -> ApplicationTestBuilder {
        self.dataStore = dataStore
        return self
    }

    @discardableResult
    func with(_ userPreferences: UserPreferences) -> ApplicationTestBuilder {
        self.userPreferences = userPreferences
        return self
    }

    @discardableResult
    func with(timeIntervalForUpcomingEventsSinceNow: TimeInterval) -> ApplicationTestBuilder {
        self.timeIntervalForUpcomingEventsSinceNow = timeIntervalForUpcomingEventsSinceNow
        return self
    }

    @discardableResult
    func with(_ imageAPI: FakeImageAPI) -> ApplicationTestBuilder {
        self.imageAPI = imageAPI
        return self
    }

    @discardableResult
    func with(_ imageRepository: CapturingImageRepository) -> ApplicationTestBuilder {
        self.imageRepository = imageRepository
        return self
    }

    @discardableResult
    func with(_ urlOpener: CapturingURLOpener) -> ApplicationTestBuilder {
        self.urlOpener = urlOpener
        return self
    }

    @discardableResult
    func with(_ collectThemAllRequestFactory: CollectThemAllRequestFactory) -> ApplicationTestBuilder {
        self.collectThemAllRequestFactory = collectThemAllRequestFactory
        return self
    }

    func loggedInWithValidCredential() -> ApplicationTestBuilder {
        let credential = Credential(username: "User",
                                    registrationNumber: 42,
                                    authenticationToken: "Token",
                                    tokenExpiryDate: .distantFuture)
        return with(credential)
    }

    @discardableResult
    func with(_ forceUpgradeRequired: ForceRefreshRequired) -> ApplicationTestBuilder {
        self.forceUpgradeRequired = forceUpgradeRequired
        return self
    }

    @discardableResult
    func build() -> Context {
        let dateDistanceCalculator = StubDateDistanceCalculator()
        let conventionStartDateRepository = StubConventionStartDateRepository()
        let significantTimeChangeAdapter = CapturingSignificantTimeChangeAdapter()
        let longRunningTaskManager = FakeLongRunningTaskManager()
        let notificationsService = CapturingNotificationScheduler()
        let hoursDateFormatter = FakeHoursDateFormatter()
        let mapCoordinateRender = CapturingMapCoordinateRender()
        let app = EurofurenceSessionBuilder()
            .with(stubClock)
            .with(capturingCredentialStore)
            .with(dataStore)
            .with(loginAPI)
            .with(privateMessagesAPI)
            .with(pushPermissionsRequester)
            .with(capturingTokenRegistration)
            .with(userPreferences)
            .with(syncAPI)
            .with(dateDistanceCalculator)
            .with(conventionStartDateRepository)
            .with(timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow)
            .with(imageAPI)
            .with(imageRepository)
            .with(significantTimeChangeAdapter)
            .with(urlOpener)
            .with(collectThemAllRequestFactory)
            .with(longRunningTaskManager)
            .with(notificationsService)
            .with(hoursDateFormatter)
            .with(mapCoordinateRender)
            .with(forceUpgradeRequired)
            .build()

        return Context(application: app,
                       clock: stubClock,
                       capturingTokenRegistration: capturingTokenRegistration,
                       capturingCredentialStore: capturingCredentialStore,
                       loginAPI: loginAPI,
                       privateMessagesAPI: privateMessagesAPI,
                       syncAPI: syncAPI,
                       dataStore: dataStore,
                       dateDistanceCalculator: dateDistanceCalculator,
                       conventionStartDateRepository: conventionStartDateRepository,
                       imageAPI: imageAPI,
                       imageRepository: imageRepository,
                       significantTimeChangeAdapter: significantTimeChangeAdapter,
                       urlOpener: urlOpener,
                       longRunningTaskManager: longRunningTaskManager,
                       notificationScheduler: notificationsService,
                       hoursDateFormatter: hoursDateFormatter,
                       mapCoordinateRender: mapCoordinateRender)
    }

}
