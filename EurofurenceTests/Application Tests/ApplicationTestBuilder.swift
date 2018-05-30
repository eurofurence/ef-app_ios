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
    
    func fetchImage(identifier: String, completionHandler: @escaping (Data?) -> Void) {
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
    
    func stubbedImage(for identifier: String) -> Data {
        return identifier.data(using: .utf8)!
    }
    
}

class CapturingImageRepository: ImageRepository {
    
    fileprivate var savedImages = [ImageEntity]()
    func save(_ image: ImageEntity) {
        savedImages.append(image)
    }
    
}

extension CapturingImageRepository {
    
    func didSave(_ images: [ImageEntity]) -> Bool {
        return savedImages.contains(elementsFrom: images)
    }
    
}

class ApplicationTestBuilder {
    
    struct Context {
        var application: EurofurenceApplicationProtocol
        
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
        
        func expectedAnnouncements(from syncResponse: APISyncResponse) -> [Announcement2] {
            return Announcement2.fromServerModels(syncResponse.announcements.changed.sorted { (first, second) -> Bool in
                return first.lastChangedDateTime.compare(second.lastChangedDateTime) == .orderedAscending
            })
        }
        
        func makeExpectedEvent(from event: APIEvent, response: APISyncResponse) -> Event2 {
            let expectedRoom = response.rooms.changed.first(where: { $0.roomIdentifier == event.roomIdentifier })!
            let expectedTrack = response.tracks.changed.first(where: { $0.trackIdentifier == event.trackIdentifier })!
            let expectedPosterGraphic = imageAPI.stubbedImage(for: event.posterImageId)
            
            return Event2(title: event.title,
                          abstract: event.abstract,
                          room: Room(name: expectedRoom.name),
                          track: Track(name: expectedTrack.name),
                          hosts: event.panelHosts,
                          startDate: event.startDateTime,
                          endDate: event.endDateTime,
                          eventDescription: event.eventDescription,
                          posterGraphicPNGData: expectedPosterGraphic)
        }
        
    }
    
    private let capturingTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
    private var capturingCredentialStore = CapturingCredentialStore()
    private var stubClock = StubClock()
    private let loginAPI = CapturingLoginAPI()
    private let privateMessagesAPI = CapturingPrivateMessagesAPI()
    private var pushPermissionsRequester: PushPermissionsRequester = CapturingPushPermissionsRequester()
    private var pushPermissionsStateProviding: PushPermissionsStateProviding = CapturingPushPermissionsStateProviding()
    private var dataStore = CapturingEurofurenceDataStore()
    private var userPreferences: UserPreferences = StubUserPreferences()
    private let syncAPI = CapturingSyncAPI()
    private var timeIntervalForUpcomingEventsSinceNow: TimeInterval = .greatestFiniteMagnitude
    private var imageAPI: FakeImageAPI = FakeImageAPI()
    
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
    
    func with(_ pushPermissionsStateProviding: PushPermissionsStateProviding) -> ApplicationTestBuilder {
        self.pushPermissionsStateProviding = pushPermissionsStateProviding
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
    
    func loggedInWithValidCredential() -> ApplicationTestBuilder {
        let credential = Credential(username: "User",
                                    registrationNumber: 42,
                                    authenticationToken: "Token",
                                    tokenExpiryDate: .distantFuture)
        return with(credential)
    }
    
    @discardableResult
    func build() -> Context {
        let dateDistanceCalculator = StubDateDistanceCalculator()
        let conventionStartDateRepository = StubConventionStartDateRepository()
        let significantTimeChangeEventSource = FakeSignificantTimeChangeEventSource()
        let imageRepository = CapturingImageRepository()
        let app = EurofurenceApplicationBuilder()
            .with(stubClock)
            .with(capturingCredentialStore)
            .with(dataStore)
            .with(loginAPI)
            .with(privateMessagesAPI)
            .with(pushPermissionsRequester)
            .with(pushPermissionsStateProviding)
            .with(capturingTokenRegistration)
            .with(userPreferences)
            .with(syncAPI)
            .with(dateDistanceCalculator)
            .with(conventionStartDateRepository)
            .with(significantTimeChangeEventSource)
            .with(timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow)
            .with(imageAPI)
            .with(imageRepository)
            .build()
        
        return Context(application: app,
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
                       imageRepository: imageRepository)
    }
    
}
