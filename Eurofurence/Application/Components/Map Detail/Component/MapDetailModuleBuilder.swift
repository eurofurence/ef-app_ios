import Foundation

class MapDetailComponentBuilder {

    private var sceneFactory: MapDetailSceneFactory
    private let mapDetailViewModelFactory: MapDetailViewModelFactory

    init(mapDetailViewModelFactory: MapDetailViewModelFactory) {
        self.mapDetailViewModelFactory = mapDetailViewModelFactory
        sceneFactory = StoryboardMapDetailSceneFactory()
    }

    @discardableResult
    func with(_ sceneFactory: MapDetailSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> MapDetailComponentFactory {
        MapDetailComponentFactoryImpl(
            sceneFactory: sceneFactory,
            mapDetailViewModelFactory: mapDetailViewModelFactory
        )
    }

}
