import EurofurenceModel

public class AdditionalServicesComponentBuilder {
    
    private let repository: AdditionalServicesRepository
    private var sceneFactory: HybridWebSceneFactory
    
    public init(repository: AdditionalServicesRepository) {
        self.repository = repository
        sceneFactory = StoryboardHybridWebSceneFactory()
    }
    
    @discardableResult
    public func with(_ sceneFactory: HybridWebSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }
    
    public func build() -> AdditionalServicesComponentFactory {
        AdditionalServicesComponentFactoryImpl(
            repository: repository,
            sceneFactory: sceneFactory
        )
    }
    
}
