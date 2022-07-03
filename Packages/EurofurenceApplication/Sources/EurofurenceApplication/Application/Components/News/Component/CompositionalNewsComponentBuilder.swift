import EurofurenceModel

public class CompositionalNewsComponentBuilder {
    
    private var sceneFactory: any CompositionalNewsSceneFactory
    private var widgets = [any NewsWidget]()
    private let refreshService: any RefreshService
    
    public init(refreshService: any RefreshService) {
        self.refreshService = refreshService
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
        return CompositionalNewsComponentFactory(
            sceneFactory: sceneFactory,
            widgets: widgets,
            refreshService: refreshService
        )
    }
    
}
