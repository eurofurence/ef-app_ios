import EurofurenceModel

extension EurofurenceSessionBuilder {
    
    public static func buildingForEurofurenceApplication() -> EurofurenceSessionBuilder {
        let remoteConfigurationLoader = FirebaseRemoteConfigurationLoader()
        let conventionStartDateRepository = RemotelyConfiguredConventionStartDateRepository(
            remoteConfigurationLoader: remoteConfigurationLoader
        )
        
        let mandatory = EurofurenceSessionBuilder.Mandatory(
            conventionIdentifier: .currentConvention,
            conventionStartDateRepository: conventionStartDateRepository,
            shareableURLFactory: CIDBasedShareableURLFactory(conventionIdentifier: .currentConvention)
        )
        
        return EurofurenceSessionBuilder(mandatory: mandatory)
            .with(UpdateRemoteConfigRefreshCollaboration(remoteConfigurationLoader: remoteConfigurationLoader))
    }
    
}
