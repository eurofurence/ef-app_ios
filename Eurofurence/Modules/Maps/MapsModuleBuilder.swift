import Foundation

class MapsModuleBuilder {

    private let interactor: MapsInteractor
    private var sceneFactory: MapsSceneFactory

    init(interactor: MapsInteractor) {
        self.interactor = interactor
        sceneFactory = StoryboardMapsScenefactory()
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
