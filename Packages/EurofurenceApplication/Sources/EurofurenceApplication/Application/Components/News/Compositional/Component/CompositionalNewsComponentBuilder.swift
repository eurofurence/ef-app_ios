public class CompositionalNewsComponentBuilder {
    
    private var sceneFactory: any CompositionalNewsSceneFactory
    private var widgets = [any NewsWidget]()
    
    public init() {
        sceneFactory = DefaultCompositionalNewsSceneFactory()
    }
    
    public func with(_ sceneFactory: any CompositionalNewsSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }
    
    public func with(_ widget: any NewsWidget) -> Self {
        self.widgets.append(widget)
        return self
    }
    
    public func build() -> any NewsComponentFactory {
        return CompositionalNewsComponentFactory(sceneFactory: sceneFactory, widgets: widgets)
    }
    
}
