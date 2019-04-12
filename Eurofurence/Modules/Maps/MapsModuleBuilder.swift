import Foundation

class MapsModuleBuilder {

    private var interactor: MapsInteractor
    private var sceneFactory: MapsSceneFactory

    init() {
        interactor = DefaultMapsInteractor()
        sceneFactory = StoryboardMapsScenefactory()
    }

    @discardableResult
    func with(_ interactor: MapsInteractor) -> MapsModuleBuilder {
        self.interactor = interactor
        return self
    }

    @discardableResult
    func with(_ sceneFactory: MapsSceneFactory) -> MapsModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> MapsModuleProviding {
        return MapsModule(sceneFactory: sceneFactory, interactor: interactor)
    }

}
