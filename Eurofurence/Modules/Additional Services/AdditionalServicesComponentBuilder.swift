import EurofurenceModel

class AdditionalServicesComponentBuilder {
    
    private let repository: AdditionalServicesRepository
    private var sceneFactory: HybridWebSceneFactory
    
    init(repository: AdditionalServicesRepository) {
        self.repository = repository
        sceneFactory = StoryboardHybridWebSceneFactory()
    }
    
    @discardableResult
    func with(_ sceneFactory: HybridWebSceneFactory) -> AdditionalServicesComponentBuilder {
        self.sceneFactory = sceneFactory
        return self
    }
    
    func build() -> AdditionalServicesComponentFactoryImpl {
        AdditionalServicesComponentFactoryImpl(
            repository: repository,
            sceneFactory: sceneFactory
        )
    }
    
}
