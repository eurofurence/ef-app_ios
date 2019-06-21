import EurofurenceModel

class AdditionalServicesModuleBuilder {
    
    private var sceneFactory: HybridWebSceneFactory
    
    init(service: AdditionalServicesRepository) {
        sceneFactory = StoryboardHybridWebSceneFactory()
    }
    
    @discardableResult
    func with(_ sceneFactory: HybridWebSceneFactory) -> AdditionalServicesModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }
    
    func build() -> AdditionalServicesModule {
        return AdditionalServicesModule(sceneFactory: sceneFactory)
    }
    
}
