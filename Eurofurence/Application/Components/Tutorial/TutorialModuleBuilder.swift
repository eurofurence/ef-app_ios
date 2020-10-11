import EurofurenceModel

public class TutorialModuleBuilder {

    private let alertRouter: AlertRouter
    private var tutorialSceneFactory: TutorialSceneFactory
    private var presentationAssets: PresentationAssets
    private var tutorialStateProviding: UserCompletedTutorialStateProviding
    private var networkReachability: NetworkReachability
    private var witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest

    public init(alertRouter: AlertRouter) {
        self.alertRouter = alertRouter
        
        tutorialSceneFactory = StoryboardTutorialSceneFactory()
        presentationAssets = ApplicationPresentationAssets()
        tutorialStateProviding = UserDefaultsTutorialStateProvider(userDefaults: .standard)
        networkReachability = SystemConfigurationNetworkReachability()
        witnessedTutorialPushPermissionsRequest = UserDefaultsWitnessedTutorialPushPermissionsRequest()
    }

    public func with(_ tutorialSceneFactory: TutorialSceneFactory) -> Self {
        self.tutorialSceneFactory = tutorialSceneFactory
        return self
    }

    public func with(_ presentationAssets: PresentationAssets) -> Self {
        self.presentationAssets = presentationAssets
        return self
    }

    public func with(_ tutorialStateProviding: UserCompletedTutorialStateProviding) -> Self {
        self.tutorialStateProviding = tutorialStateProviding
        return self
    }

    public func with(_ networkReachability: NetworkReachability) -> Self {
        self.networkReachability = networkReachability
        return self
    }

    public func with(_ witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest) -> Self {
        self.witnessedTutorialPushPermissionsRequest = witnessedTutorialPushPermissionsRequest
        return self
    }
    
    public func build() -> TutorialComponentFactory {
        TutorialModule(
            tutorialSceneFactory: tutorialSceneFactory,
            presentationAssets: presentationAssets,
            alertRouter: alertRouter,
            tutorialStateProviding: tutorialStateProviding,
            networkReachability: networkReachability,
            witnessedTutorialPushPermissionsRequest: witnessedTutorialPushPermissionsRequest
        )
    }
    
}
