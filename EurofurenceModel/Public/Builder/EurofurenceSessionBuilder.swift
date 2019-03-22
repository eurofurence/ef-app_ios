//
//  EurofurenceApplicationBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public class EurofurenceSessionBuilder {
    
    private let conventionIdentifier: ConventionIdentifier

    private var userPreferences: UserPreferences
    private var dataStoreFactory: DataStoreFactory
    private var remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration?
    private var pushPermissionsRequester: PushPermissionsRequester?
    private var clock: Clock
    private var credentialStore: CredentialStore
    private var api: API
    private var dateDistanceCalculator: DateDistanceCalculator
    private var conventionStartDateRepository: ConventionStartDateRepository
    private var timeIntervalForUpcomingEventsSinceNow: TimeInterval
    private var imageRepository: ImageRepository
    private var significantTimeChangeAdapter: SignificantTimeChangeAdapter?
    private var urlOpener: URLOpener?
    private var collectThemAllRequestFactory: CollectThemAllRequestFactory
    private var longRunningTaskManager: LongRunningTaskManager?
    private var hoursDateFormatter: HoursDateFormatter
    private var mapCoordinateRender: MapCoordinateRender?
    private var forceRefreshRequired: ForceRefreshRequired

    public init(conventionIdentifier: ConventionIdentifier) {
        self.conventionIdentifier = conventionIdentifier
        
        userPreferences = UserDefaultsPreferences()
        dataStoreFactory = CoreDataStoreFactory()

        let jsonSession = URLSessionBasedJSONSession.shared
        let apiUrl = CIDAPIURLProviding(conventionIdentifier: conventionIdentifier)
        api = JSONAPI(jsonSession: jsonSession, apiUrl: apiUrl)

        clock = SystemClock.shared
        credentialStore = KeychainCredentialStore()
        dateDistanceCalculator = FoundationDateDistanceCalculator()
        conventionStartDateRepository = EF24StartDateRepository()
        timeIntervalForUpcomingEventsSinceNow = 3600
        imageRepository = PersistentImageRepository()
        collectThemAllRequestFactory = DefaultCollectThemAllRequestFactory()
        hoursDateFormatter = FoundationHoursDateFormatter.shared
        forceRefreshRequired = UserDefaultsForceRefreshRequired()
    }

    @discardableResult
    public func with(_ userPreferences: UserPreferences) -> EurofurenceSessionBuilder {
        self.userPreferences = userPreferences
        return self
    }

    @discardableResult
    public func with(_ dataStoreFactory: DataStoreFactory) -> EurofurenceSessionBuilder {
        self.dataStoreFactory = dataStoreFactory
        return self
    }

    @discardableResult
    public func with(_ remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration) -> EurofurenceSessionBuilder {
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        return self
    }

    @discardableResult
    public func with(_ pushPermissionsRequester: PushPermissionsRequester) -> EurofurenceSessionBuilder {
        self.pushPermissionsRequester = pushPermissionsRequester
        return self
    }

    @discardableResult
    public func with(_ clock: Clock) -> EurofurenceSessionBuilder {
        self.clock = clock
        return self
    }

    @discardableResult
    public func with(_ credentialStore: CredentialStore) -> EurofurenceSessionBuilder {
        self.credentialStore = credentialStore
        return self
    }

    @discardableResult
    public func with(_ dateDistanceCalculator: DateDistanceCalculator) -> EurofurenceSessionBuilder {
        self.dateDistanceCalculator = dateDistanceCalculator
        return self
    }

    @discardableResult
    public func with(_ conventionStartDateRepository: ConventionStartDateRepository) -> EurofurenceSessionBuilder {
        self.conventionStartDateRepository = conventionStartDateRepository
        return self
    }

    @discardableResult
    public func with(timeIntervalForUpcomingEventsSinceNow: TimeInterval) -> EurofurenceSessionBuilder {
        self.timeIntervalForUpcomingEventsSinceNow = timeIntervalForUpcomingEventsSinceNow
        return self
    }

    @discardableResult
    public func with(_ api: API) -> EurofurenceSessionBuilder {
        self.api = api
        return self
    }

    @discardableResult
    public func with(_ imageRepository: ImageRepository) -> EurofurenceSessionBuilder {
        self.imageRepository = imageRepository
        return self
    }

    @discardableResult
    public func with(_ significantTimeChangeAdapter: SignificantTimeChangeAdapter) -> EurofurenceSessionBuilder {
        self.significantTimeChangeAdapter = significantTimeChangeAdapter
        return self
    }

    @discardableResult
    public func with(_ urlOpener: URLOpener) -> EurofurenceSessionBuilder {
        self.urlOpener = urlOpener
        return self
    }

    @discardableResult
    public func with(_ collectThemAllRequestFactory: CollectThemAllRequestFactory) -> EurofurenceSessionBuilder {
        self.collectThemAllRequestFactory = collectThemAllRequestFactory
        return self
    }

    @discardableResult
    public func with(_ longRunningTaskManager: LongRunningTaskManager) -> EurofurenceSessionBuilder {
        self.longRunningTaskManager = longRunningTaskManager
        return self
    }

    @discardableResult
    public func with(_ hoursDateFormatter: HoursDateFormatter) -> EurofurenceSessionBuilder {
        self.hoursDateFormatter = hoursDateFormatter
        return self
    }

    @discardableResult
    public func with(_ mapCoordinateRender: MapCoordinateRender) -> EurofurenceSessionBuilder {
        self.mapCoordinateRender = mapCoordinateRender
        return self
    }

    @discardableResult
    public func with(_ forceRefreshRequired: ForceRefreshRequired) -> EurofurenceSessionBuilder {
        self.forceRefreshRequired = forceRefreshRequired
        return self
    }

    public func build() -> EurofurenceSession {
        return ConcreteSession(conventionIdentifier: conventionIdentifier,
                               api: api,
                               userPreferences: userPreferences,
                               dataStoreFactory: dataStoreFactory,
                               remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration,
                               pushPermissionsRequester: pushPermissionsRequester,
                               clock: clock,
                               credentialStore: credentialStore,
                               dateDistanceCalculator: dateDistanceCalculator,
                               conventionStartDateRepository: conventionStartDateRepository,
                               timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow,
                               imageRepository: imageRepository,
                               significantTimeChangeAdapter: significantTimeChangeAdapter,
                               urlOpener: urlOpener,
                               collectThemAllRequestFactory: collectThemAllRequestFactory,
                               longRunningTaskManager: longRunningTaskManager,
                               hoursDateFormatter: hoursDateFormatter,
                               mapCoordinateRender: mapCoordinateRender,
                               forceRefreshRequired: forceRefreshRequired)
    }

}
