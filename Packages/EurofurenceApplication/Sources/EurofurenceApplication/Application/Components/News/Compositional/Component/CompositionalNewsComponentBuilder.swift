public class CompositionalNewsComponentBuilder {
    
    private var sceneFactory: CompositionalNewsSceneFactory
    
    public init() {
        sceneFactory = DefaultCompositionalNewsSceneFactory()
    }
    
    public func with(_ sceneFactory: CompositionalNewsSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }
    
    public func build() -> NewsComponentFactory {
        return CompositionalNewsComponentFactory(sceneFactory: sceneFactory)
    }
    
}
