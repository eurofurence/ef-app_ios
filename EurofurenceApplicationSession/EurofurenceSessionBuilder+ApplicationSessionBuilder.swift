import EurofurenceModel

extension EurofurenceSessionBuilder {
    
    public static func buildingForEurofurenceApplication() -> EurofurenceSessionBuilder {
        let jsonSession = URLSessionBasedJSONSession.shared
        let buildConfiguration = PreprocessorBuildConfigurationProviding()
        
        let apiUrl = CIDAPIURLProviding(conventionIdentifier: .currentConvention)
        let fcmRegistration = EurofurenceFCMDeviceRegistration(JSONSession: jsonSession, urlProviding: apiUrl)
        let remoteNotificationsTokenRegistration = FirebaseRemoteNotificationsTokenRegistration(
            buildConfiguration: buildConfiguration,
            appVersion: BundleAppVersionProviding.shared,
            conventionIdentifier: .currentConvention,
            firebaseAdapter: FirebaseMessagingAdapter(),
            fcmRegistration: fcmRegistration
        )
        
        let remoteConfigurationLoader = FirebaseRemoteConfigurationLoader()
        let conventionStartDateRepository = RemotelyConfiguredConventionStartDateRepository(
            remoteConfigurationLoader: remoteConfigurationLoader
        )
        
        let apiURL = CIDAPIURLProviding(conventionIdentifier: .currentConvention)
        
        let mandatory = EurofurenceSessionBuilder.Mandatory(
            conventionIdentifier: .currentConvention,
            apiURL: apiURL,
            conventionStartDateRepository: conventionStartDateRepository,
            shareableURLFactory: CIDBasedShareableURLFactory(conventionIdentifier: .currentConvention)
        )
        
        return EurofurenceSessionBuilder(mandatory: mandatory)
            .with(remoteNotificationsTokenRegistration)
            .with(UpdateRemoteConfigRefreshCollaboration(remoteConfigurationLoader: remoteConfigurationLoader))
    }
    
}
