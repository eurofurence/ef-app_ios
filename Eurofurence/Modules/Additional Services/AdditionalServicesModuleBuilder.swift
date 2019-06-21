import EurofurenceModel

class AdditionalServicesModuleBuilder {
    
    private let repository: AdditionalServicesRepository
    private var sceneFactory: HybridWebSceneFactory
    
    init(repository: AdditionalServicesRepository) {
        self.repository = repository
        sceneFactory = StoryboardHybridWebSceneFactory()
    }
    
    @discardableResult
    func with(_ sceneFactory: HybridWebSceneFactory) -> AdditionalServicesModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }
    
    func build() -> AdditionalServicesModule {
        return AdditionalServicesModule(repository: repository, sceneFactory: sceneFactory)
    }
    
}
