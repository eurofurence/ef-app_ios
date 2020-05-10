import Foundation

class MapsComponentBuilder {

    private let mapsViewModelFactory: MapsViewModelFactory
    private var sceneFactory: MapsSceneFactory

    init(mapsViewModelFactory: MapsViewModelFactory) {
        self.mapsViewModelFactory = mapsViewModelFactory
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
            mapsViewModelFactory: mapsViewModelFactory
        )
    }

}
