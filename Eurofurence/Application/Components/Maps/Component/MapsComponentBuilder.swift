import Foundation

public class MapsComponentBuilder {

    private let mapsViewModelFactory: MapsViewModelFactory
    private var sceneFactory: MapsSceneFactory

    public init(mapsViewModelFactory: MapsViewModelFactory) {
        self.mapsViewModelFactory = mapsViewModelFactory
        sceneFactory = StoryboardMapsScenefactory()
    }

    @discardableResult
    public func with(_ sceneFactory: MapsSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }

    public func build() -> MapsComponentFactory {
        MapsComponentFactoryImpl(
            sceneFactory: sceneFactory,
            mapsViewModelFactory: mapsViewModelFactory
        )
    }

}
