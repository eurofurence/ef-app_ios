import Foundation

class MapsComponentBuilder {

    private let interactor: MapsViewModelFactory
    private var sceneFactory: MapsSceneFactory

    init(interactor: MapsViewModelFactory) {
        self.interactor = interactor
        sceneFactory = StoryboardMapsScenefactory()
    }

    @discardableResult
    func with(_ sceneFactory: MapsSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> MapsComponentFactory {
        MapsComponentFactoryImpl(
            sceneFactory: sceneFactory,
            interactor: interactor
        )
    }

}
