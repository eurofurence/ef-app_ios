import Foundation

class MapDetailModuleBuilder {

    private var sceneFactory: MapDetailSceneFactory
    private var interactor: MapDetailInteractor

    init() {
        sceneFactory = StoryboardMapDetailSceneFactory()
        interactor = DefaultMapDetailInteractor()
    }

    @discardableResult
    func with(_ sceneFactory: MapDetailSceneFactory) -> MapDetailModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    @discardableResult
    func with(_ interactor: MapDetailInteractor) -> MapDetailModuleBuilder {
        self.interactor = interactor
        return self
    }

    func build() -> MapDetailModuleProviding {
        return MapDetailModule(sceneFactory: sceneFactory, interactor: interactor)
    }

}
