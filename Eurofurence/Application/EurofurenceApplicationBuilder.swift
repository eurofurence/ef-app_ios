//
//  EurofurenceApplicationBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class EurofurenceApplicationBuilder {

    private var userPreferences: UserPreferences
    private var dataStore: EurofurenceDataStore
    private var remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration
    private var pushPermissionsRequester: PushPermissionsRequester
    private var pushPermissionsStateProviding: PushPermissionsStateProviding
    private var clock: Clock
    private var credentialStore: CredentialStore
    private var loginAPI: LoginAPI
    private var privateMessagesAPI: PrivateMessagesAPI
    private var syncAPI: SyncAPI
    private var dateDistanceCalculator: DateDistanceCalculator
    private var conventionStartDateRepository: ConventionStartDateRepository
    private var significantTimeChangeEventSource: SignificantTimeChangeEventSource
    private var timeIntervalForUpcomingEventsSinceNow: TimeInterval
    private var imageAPI: ImageAPI
    private var imageRepository: ImageRepository
    private var significantTimeChangeAdapter: SignificantTimeChangeAdapter
    private var urlOpener: URLOpener

    init() {
        userPreferences = UserDefaultsPreferences()
        dataStore = CoreDataEurofurenceDataStore()

        let jsonSession = URLSessionBasedJSONSession()
        let buildConfiguration = PreprocessorBuildConfigurationProviding()
        let apiUrl = BuildConfigurationV2ApiUrlProviding(buildConfiguration)

        let fcmRegistration = EurofurenceFCMDeviceRegistration(JSONSession: jsonSession)
        remoteNotificationsTokenRegistration = FirebaseRemoteNotificationsTokenRegistration(buildConfiguration: buildConfiguration,
                                                                                            appVersion: BundleAppVersionProviding(),
                                                                                            firebaseAdapter: FirebaseMessagingAdapter(),
                                                                                            fcmRegistration: fcmRegistration)

        pushPermissionsRequester = ApplicationPushPermissionsRequester()
        pushPermissionsStateProviding = UserDefaultsWitnessedSystemPushPermissionsRequest()
        clock = SystemClock()
        credentialStore = KeychainCredentialStore()
        loginAPI = V2LoginAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        privateMessagesAPI = V2PrivateMessagesAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        syncAPI = V2SyncAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        imageAPI = V2ImageAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        dateDistanceCalculator = FoundationDateDistanceCalculator()
        conventionStartDateRepository = EF24StartDateRepository()
        significantTimeChangeEventSource = ApplicationSignificantTimeChangeEventSource.shared
        timeIntervalForUpcomingEventsSinceNow = 3600
        imageRepository = PersistentImageRepository()
        significantTimeChangeAdapter = ApplicationSignificantTimeChangeAdapter()
        urlOpener = AppURLOpener()
    }

    @discardableResult
    func with(_ userPreferences: UserPreferences) -> EurofurenceApplicationBuilder {
        self.userPreferences = userPreferences
        return self
    }

    @discardableResult
    func with(_ dataStore: EurofurenceDataStore) -> EurofurenceApplicationBuilder {
        self.dataStore = dataStore
        return self
    }

    @discardableResult
    func with(_ remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration) -> EurofurenceApplicationBuilder {
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration
        return self
    }

    @discardableResult
    func with(_ pushPermissionsRequester: PushPermissionsRequester) -> EurofurenceApplicationBuilder {
        self.pushPermissionsRequester = pushPermissionsRequester
        return self
    }

    @discardableResult
    func with(_ pushPermissionsStateProviding: PushPermissionsStateProviding) -> EurofurenceApplicationBuilder {
        self.pushPermissionsStateProviding = pushPermissionsStateProviding
        return self
    }

    @discardableResult
    func with(_ clock: Clock) -> EurofurenceApplicationBuilder {
        self.clock = clock
        return self
    }

    @discardableResult
    func with(_ credentialStore: CredentialStore) -> EurofurenceApplicationBuilder {
        self.credentialStore = credentialStore
        return self
    }

    @discardableResult
    func with(_ loginAPI: LoginAPI) -> EurofurenceApplicationBuilder {
        self.loginAPI = loginAPI
        return self
    }

    @discardableResult
    func with(_ privateMessagesAPI: PrivateMessagesAPI) -> EurofurenceApplicationBuilder {
        self.privateMessagesAPI = privateMessagesAPI
        return self
    }

    @discardableResult
    func with(_ syncAPI: SyncAPI) -> EurofurenceApplicationBuilder {
        self.syncAPI = syncAPI
        return self
    }

    @discardableResult
    func with(_ dateDistanceCalculator: DateDistanceCalculator) -> EurofurenceApplicationBuilder {
        self.dateDistanceCalculator = dateDistanceCalculator
        return self
    }

    @discardableResult
    func with(_ conventionStartDateRepository: ConventionStartDateRepository) -> EurofurenceApplicationBuilder {
        self.conventionStartDateRepository = conventionStartDateRepository
        return self
    }

    @discardableResult
    func with(_ significantTimeChangeEventSource: SignificantTimeChangeEventSource) -> EurofurenceApplicationBuilder {
        self.significantTimeChangeEventSource = significantTimeChangeEventSource
        return self
    }

    @discardableResult
    func with(timeIntervalForUpcomingEventsSinceNow: TimeInterval) -> EurofurenceApplicationBuilder {
        self.timeIntervalForUpcomingEventsSinceNow = timeIntervalForUpcomingEventsSinceNow
        return self
    }

    @discardableResult
    func with(_ imageAPI: ImageAPI) -> EurofurenceApplicationBuilder {
        self.imageAPI = imageAPI
        return self
    }

    @discardableResult
    func with(_ imageRepository: ImageRepository) -> EurofurenceApplicationBuilder {
        self.imageRepository = imageRepository
        return self
    }

    @discardableResult
    func with(_ significantTimeChangeAdapter: SignificantTimeChangeAdapter) -> EurofurenceApplicationBuilder {
        self.significantTimeChangeAdapter = significantTimeChangeAdapter
        return self
    }

    @discardableResult
    func with(_ urlOpener: URLOpener) -> EurofurenceApplicationBuilder {
        self.urlOpener = urlOpener
        return self
    }

    func build() -> EurofurenceApplicationProtocol {
        return EurofurenceApplication(userPreferences: userPreferences,
                                      dataStore: dataStore,
                                      remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration,
                                      pushPermissionsRequester: pushPermissionsRequester,
                                      pushPermissionsStateProviding: pushPermissionsStateProviding,
                                      clock: clock,
                                      credentialStore: credentialStore,
                                      loginAPI: loginAPI,
                                      privateMessagesAPI: privateMessagesAPI,
                                      syncAPI: syncAPI,
                                      imageAPI: imageAPI,
                                      dateDistanceCalculator: dateDistanceCalculator,
                                      conventionStartDateRepository: conventionStartDateRepository,
                                      significantTimeChangeEventSource: significantTimeChangeEventSource,
                                      timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow,
                                      imageRepository: imageRepository,
                                      significantTimeChangeAdapter: significantTimeChangeAdapter,
                                      urlOpener: urlOpener)
    }

}
