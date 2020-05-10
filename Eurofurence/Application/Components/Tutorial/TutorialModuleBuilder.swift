import EurofurenceModel

class TutorialModuleBuilder {

    private let alertRouter: AlertRouter
    private var tutorialSceneFactory: TutorialSceneFactory
    private var presentationAssets: PresentationAssets
    private var tutorialStateProviding: UserCompletedTutorialStateProviding
    private var networkReachability: NetworkReachability
    private var witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest

    init(alertRouter: AlertRouter) {
        self.alertRouter = alertRouter
        
        tutorialSceneFactory = StoryboardTutorialSceneFactory()
        presentationAssets = ApplicationPresentationAssets()
        tutorialStateProviding = UserDefaultsTutorialStateProvider(userDefaults: .standard)
        networkReachability = SystemConfigurationNetworkReachability()
        witnessedTutorialPushPermissionsRequest = UserDefaultsWitnessedTutorialPushPermissionsRequest(userDefaults: .standard)
    }

    func with(_ tutorialSceneFactory: TutorialSceneFactory) -> TutorialModuleBuilder {
        self.tutorialSceneFactory = tutorialSceneFactory
        return self
    }

    func with(_ presentationAssets: PresentationAssets) -> TutorialModuleBuilder {
        self.presentationAssets = presentationAssets
        return self
    }

    func with(_ tutorialStateProviding: UserCompletedTutorialStateProviding) -> TutorialModuleBuilder {
        self.tutorialStateProviding = tutorialStateProviding
        return self
    }

    func with(_ networkReachability: NetworkReachability) -> TutorialModuleBuilder {
        self.networkReachability = networkReachability
        return self
    }

    func with(_ witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest) -> TutorialModuleBuilder {
        self.witnessedTutorialPushPermissionsRequest = witnessedTutorialPushPermissionsRequest
        return self
    }

    func build() -> TutorialComponentFactory {
        return TutorialModule(tutorialSceneFactory: tutorialSceneFactory,
                                          presentationAssets: presentationAssets,
                                          alertRouter: alertRouter,
                                          tutorialStateProviding: tutorialStateProviding,
                                          networkReachability: networkReachability,
                                          witnessedTutorialPushPermissionsRequest: witnessedTutorialPushPermissionsRequest)
    }

}
