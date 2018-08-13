//
//  ApplicationTestBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeImageAPI: ImageAPI {
    
    private(set) var downloadedImageIdentifiers = [String]()
    func fetchImage(identifier: String, completionHandler: @escaping (Data?) -> Void) {
        downloadedImageIdentifiers.append(identifier)
        completionHandler(identifier.data(using: .utf8)!)
    }
    
}

class SlowFakeImageAPI: FakeImageAPI {
    
    fileprivate var pendingFetches = [() -> Void]()
    
    var numberOfPendingFetches: Int {
        return pendingFetches.count
    }
    
    override func fetchImage(identifier: String, completionHandler: @escaping (Data?) -> Void) {
        pendingFetches.append {
            super.fetchImage(identifier: identifier, completionHandler: completionHandler)
        }
    }
    
}

extension SlowFakeImageAPI {
    
    func resolvePendingFetches() {
        pendingFetches.forEach({ $0() })
        pendingFetches.removeAll()
    }
    
    func resolveNextFetch() {
        guard pendingFetches.count > 0 else { return }
        
        let next = pendingFetches.remove(at: 0)
        next()
    }
    
}

extension FakeImageAPI {
    
    func stubbedImage(for identifier: String?) -> Data? {
        return identifier?.data(using: .utf8)
    }
    
}

class CapturingImageRepository: ImageRepository {
    
    fileprivate var savedImages = [ImageEntity]()
    func save(_ image: ImageEntity) {
        savedImages.append(image)
    }
    
    private(set) var deletedImages = [String]()
    func deleteEntity(identifier: String) {
        deletedImages.append(identifier)
    }
    
    func loadImage(identifier: String) -> ImageEntity? {
        return savedImages.first { $0.identifier == identifier }
    }
    
    func containsImage(identifier: String) -> Bool {
        return savedImages.contains(where: { $0.identifier == identifier })
    }
    
}

extension CapturingImageRepository {
    
    func didSave(_ images: [ImageEntity]) -> Bool {
        return savedImages.contains(elementsFrom: images)
    }
    
    func stub(identifier: String) {
        let entity = ImageEntity(identifier: identifier, pngImageData: identifier.data(using: .utf8)!)
        save(entity)
    }
    
    func stub(identifiers: [String]) {
        identifiers.forEach(stub)
    }
    
    func stubEverything(_ response: APISyncResponse) {
        var identifiers: [String] = []
        let events = response.events.changed
        identifiers.append(contentsOf: events.compactMap({ $0.bannerImageId }))
        identifiers.append(contentsOf: events.compactMap({ $0.posterImageId }))
        
        identifiers.forEach(stub)
    }
    
}

class CapturingSignificantTimeChangeAdapter: SignificantTimeChangeAdapter {
    
    private(set) var delegate: SignificantTimeChangeAdapterDelegate?
    func setDelegate(_ delegate: SignificantTimeChangeAdapterDelegate) {
        self.delegate = delegate
    }
    
}

extension CapturingSignificantTimeChangeAdapter {
    
    func simulateSignificantTimeChange() {
        delegate?.significantTimeChangeDidOccur()
    }
    
}

class FakeLongRunningTaskManager: LongRunningTaskManager {
    
    var finishedTask: Bool {
        return terminatedLongRunningTaskToken == AnyHashable(stubTaskToken)
    }
    
    let stubTaskToken = String.random
    private(set) var didBeginTask = false
    func beginLongRunningTask() -> AnyHashable {
        didBeginTask = true
        return stubTaskToken
    }
    
    private(set) var terminatedLongRunningTaskToken: AnyHashable?
    func finishLongRunningTask(token: AnyHashable) {
        terminatedLongRunningTaskToken = token
    }
    
}

class CapturingNotificationsService: NotificationsService {
    
    private(set) var capturedEventIdentifier: Event2.Identifier?
    private(set) var capturedEventNotificationScheduledDate: Date?
    private(set) var capturedEventNotificationTitle: String?
    private(set) var capturedEventNotificationBody: String?
    private(set) var capturedEventNotificationUserInfo: [ApplicationNotificationKey : String] = [:]
    func scheduleReminderForEvent(identifier: Event2.Identifier,
                                  scheduledFor date: Date,
                                  title: String,
                                  body: String,
                                  userInfo: [ApplicationNotificationKey : String]) {
        capturedEventIdentifier = identifier
        capturedEventNotificationScheduledDate = date
        capturedEventNotificationTitle = title
        capturedEventNotificationBody = body
        capturedEventNotificationUserInfo = userInfo
    }
    
    private(set) var capturedEventIdentifierToRemoveNotification: Event2.Identifier?
    func removeEventReminder(for identifier: Event2.Identifier) {
        capturedEventIdentifierToRemoveNotification = identifier
    }
    
}

class ApplicationTestBuilder {
    
    struct Context {
        var application: EurofurenceApplicationProtocol
        var clock: StubClock
        var capturingTokenRegistration: CapturingRemoteNotificationsTokenRegistration
        var capturingCredentialStore: CapturingCredentialStore
        var loginAPI: CapturingLoginAPI
        var privateMessagesAPI: CapturingPrivateMessagesAPI
        var syncAPI: CapturingSyncAPI
        var dataStore: CapturingEurofurenceDataStore
        var dateDistanceCalculator: StubDateDistanceCalculator
        var conventionStartDateRepository: StubConventionStartDateRepository
        var significantTimeChangeEventSource: FakeSignificantTimeChangeEventSource
        var imageAPI: FakeImageAPI
        var imageRepository: CapturingImageRepository
        var significantTimeChangeAdapter: CapturingSignificantTimeChangeAdapter
        var urlOpener: CapturingURLOpener
        var longRunningTaskManager: FakeLongRunningTaskManager
        var notificationsService: CapturingNotificationsService
        var hoursDateFormatter: FakeHoursDateFormatter
        var mapCoordinateRender: CapturingMapCoordinateRender
        
        var authenticationToken: String? {
            return capturingCredentialStore.persistedCredential?.authenticationToken
        }
        
        func registerForRemoteNotifications(_ deviceToken: Data = Data()) {
            application.storeRemoteNotificationsToken(deviceToken)
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
        
        func expectedUnreadAnnouncements(from syncResponse: APISyncResponse) -> [Announcement2] {
            // TODO: Needs to take into account any unread status information
            return expectedAnnouncements(from: syncResponse)
        }
        
        func expectedAnnouncements(from syncResponse: APISyncResponse) -> [Announcement2] {
            return expectedAnnouncements(from: syncResponse.announcements.changed)
        }
        
        func expectedAnnouncements(from announcements: [APIAnnouncement]) -> [Announcement2] {
            return Announcement2.fromServerModels(announcements.sorted { (first, second) -> Bool in
                return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedDescending
            })
        }
        
        func expectedAnnouncement(from announcement: APIAnnouncement) -> Announcement2 {
            return Announcement2(identifier: Announcement2.Identifier(announcement.identifier),
                                 title: announcement.title,
                                 content: announcement.content,
                                 date: announcement.lastChangedDateTime)
        }
        
        func makeExpectedEvent(from event: APIEvent, response: APISyncResponse) -> Event2 {
            let expectedRoom = response.rooms.changed.first(where: { $0.roomIdentifier == event.roomIdentifier })!
            let expectedTrack = response.tracks.changed.first(where: { $0.trackIdentifier == event.trackIdentifier })!
            let expectedPosterGraphic = imageAPI.stubbedImage(for: event.posterImageId)
            let expectedBannerGraphic = imageAPI.stubbedImage(for: event.bannerImageId)
            let tags = event.tags.or([])
            
            return Event2(identifier: Event2.Identifier(event.identifier),
                          title: event.title,
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
        
        func makeExpectedEvents(from events: [APIEvent], response: APISyncResponse) -> [Event2] {
            return events.map { makeExpectedEvent(from: $0, response: response) }
        }
        
        func makeExpectedDay(from day: APIConferenceDay) -> Day {
            return Day(date: day.date)
        }
        
        func makeExpectedDays(from response: APISyncResponse) -> [Day] {
            return response.conferenceDays.changed.map(makeExpectedDay).sorted(by: { $0.date < $1.date })
        }
        
        func makeExpectedDealer(from dealer: APIDealer) -> Dealer2 {
            return Dealer2(identifier: Dealer2.Identifier(dealer.identifier),
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
            var dealersByIndexBuckets = [String : [Dealer2]]()
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
        
        func makeExpectedMaps(from response: APISyncResponse) -> [Map2] {
            return response.maps.changed.map({ (map) -> Map2 in
                return Map2(identifier: Map2.Identifier(map.identifier), location: map.mapDescription)
            }).sorted(by: { $0.location < $1.location })
        }
        
        func expectedKnowledgeGroups(from syncResponse: APISyncResponse) -> [KnowledgeGroup2] {
            return syncResponse.knowledgeGroups.changed.map({ (group) -> KnowledgeGroup2 in
                let entries = syncResponse.knowledgeEntries.changed.filter({ $0.groupIdentifier == group.identifier }).map { (entry) in
                    return KnowledgeEntry2(identifier: KnowledgeEntry2.Identifier(entry.identifier),
                                           title: entry.title,
                                           order: entry.order,
                                           contents: entry.text,
                                           links: entry.links.map({ return Link(name: $0.name, type: Link.Kind(rawValue: $0.fragmentType.rawValue)!, contents: $0.target) }).sorted(by: { $0.name < $1.name }))
                    }.sorted(by: { $0.order < $1.order })
                
                let addressString = group.fontAwesomeCharacterAddress
                let intValue = Int(addressString, radix: 16)!
                let unicodeScalar = UnicodeScalar(intValue)!
                let character = Character(unicodeScalar)
                
                return KnowledgeGroup2(identifier: KnowledgeGroup2.Identifier(group.identifier),
                                       title: group.groupName,
                                       groupDescription: group.groupDescription,
                                       fontAwesomeCharacterAddress: character,
                                       order: group.order,
                                       entries: entries)
            }).sorted(by: { $0.order < $1.order })
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
        let significantTimeChangeEventSource = FakeSignificantTimeChangeEventSource()
        let significantTimeChangeAdapter = CapturingSignificantTimeChangeAdapter()
        let longRunningTaskManager = FakeLongRunningTaskManager()
        let notificationsService = CapturingNotificationsService()
        let hoursDateFormatter = FakeHoursDateFormatter()
        let mapCoordinateRender = CapturingMapCoordinateRender()
        let app = EurofurenceApplicationBuilder()
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
            .with(significantTimeChangeEventSource)
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
                       significantTimeChangeEventSource: significantTimeChangeEventSource,
                       imageAPI: imageAPI,
                       imageRepository: imageRepository,
                       significantTimeChangeAdapter: significantTimeChangeAdapter,
                       urlOpener: urlOpener,
                       longRunningTaskManager: longRunningTaskManager,
                       notificationsService: notificationsService,
                       hoursDateFormatter: hoursDateFormatter,
                       mapCoordinateRender: mapCoordinateRender)
    }
    
}
