//
//  EurofurenceApplicationBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

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

    init() {
        struct DummyUserPreferences: UserPreferences {
            var refreshStoreOnLaunch: Bool = true
        }

        struct DummyEurofurenceDataStore: EurofurenceDataStore {
            func resolveContentsState(completionHandler: @escaping (EurofurenceDataStoreContentsState) -> Void) {
                completionHandler(.present)
            }
            func fetchKnowledgeGroups(completionHandler: ([KnowledgeGroup2]?) -> Void) {

            }
        }

        struct DummySyncAPI: SyncAPI {
            func fetchLatestData(completionHandler: @escaping (APISyncResponse?) -> Void) {

            }
        }

        userPreferences = DummyUserPreferences()
        dataStore = DummyEurofurenceDataStore()

        let jsonSession = URLSessionBasedJSONSession()

        let fcmRegistration = EurofurenceFCMDeviceRegistration(JSONSession: jsonSession)
        remoteNotificationsTokenRegistration = FirebaseRemoteNotificationsTokenRegistration(buildConfiguration: PreprocessorBuildConfigurationProviding(),
                                                                                            appVersion: BundleAppVersionProviding(),
                                                                                            firebaseAdapter: FirebaseMessagingAdapter(),
                                                                                            fcmRegistration: fcmRegistration)

        pushPermissionsRequester = ApplicationPushPermissionsRequester()
        pushPermissionsStateProviding = UserDefaultsWitnessedSystemPushPermissionsRequest()
        clock = SystemClock()
        credentialStore = KeychainCredentialStore()
        loginAPI = V2LoginAPI(jsonSession: jsonSession)
        privateMessagesAPI = V2PrivateMessagesAPI(jsonSession: jsonSession)
        syncAPI = DummySyncAPI()
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
                                      syncAPI: syncAPI)
    }

}
