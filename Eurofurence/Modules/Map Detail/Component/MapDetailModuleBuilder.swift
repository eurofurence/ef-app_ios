import Foundation

class MapDetailComponentBuilder {

    private var sceneFactory: MapDetailSceneFactory
    private let interactor: MapDetailViewModelFactory

    init(interactor: MapDetailViewModelFactory) {
        self.interactor = interactor
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
            interactor: interactor
        )
    }

}
