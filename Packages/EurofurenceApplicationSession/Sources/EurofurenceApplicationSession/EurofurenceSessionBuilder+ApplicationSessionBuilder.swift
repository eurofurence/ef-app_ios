import EurofurenceModel

extension EurofurenceSessionBuilder {
    
    public static func buildingForEurofurenceApplication() -> EurofurenceSessionBuilder {
        let jsonSession = URLSessionBasedJSONSession.shared
        let buildConfiguration = PreprocessorBuildConfigurationProviding()
        
        let apiUrl = EFAPIURLProviding(conventionIdentifier: .currentConvention)
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
        
        let apiURL = EFAPIURLProviding(conventionIdentifier: .currentConvention)
        
        let mandatory = EurofurenceSessionBuilder.Mandatory(
            conventionIdentifier: .currentConvention,
            apiURL: apiURL,
            conventionStartDateRepository: conventionStartDateRepository,
            shareableURLFactory: EurofurenceShareableURLFactory(conventionIdentifier: .currentConvention)
        )
        
        return EurofurenceSessionBuilder(mandatory: mandatory)
            .with(remoteNotificationsTokenRegistration)
            .with(UpdateRemoteConfigRefreshCollaboration(remoteConfigurationLoader: remoteConfigurationLoader))
            .with(AppURLOpener.shared)
            .with(ApplicationSignificantTimeChangeAdapter())
            .with(ApplicationLongRunningTaskManager())
            .with(UIKitMapCoordinateRender())
    }
    
}
