import Foundation

class MapDetailModuleBuilder {

    private var sceneFactory: MapDetailSceneFactory
    private let interactor: MapDetailInteractor

    init(interactor: MapDetailInteractor) {
        self.interactor = interactor
        sceneFactory = StoryboardMapDetailSceneFactory()
    }

    @discardableResult
    func with(_ sceneFactory: MapDetailSceneFactory) -> MapDetailModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> MapDetailModuleProviding {
        return MapDetailModule(sceneFactory: sceneFactory, interactor: interactor)
    }

}
