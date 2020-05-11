import Foundation

public class MapDetailComponentBuilder {

    private var sceneFactory: MapDetailSceneFactory
    private let mapDetailViewModelFactory: MapDetailViewModelFactory

    public init(mapDetailViewModelFactory: MapDetailViewModelFactory) {
        self.mapDetailViewModelFactory = mapDetailViewModelFactory
        sceneFactory = StoryboardMapDetailSceneFactory()
    }

    @discardableResult
    public func with(_ sceneFactory: MapDetailSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }

    public func build() -> MapDetailComponentFactory {
        MapDetailComponentFactoryImpl(
            sceneFactory: sceneFactory,
            mapDetailViewModelFactory: mapDetailViewModelFactory
        )
    }

}
