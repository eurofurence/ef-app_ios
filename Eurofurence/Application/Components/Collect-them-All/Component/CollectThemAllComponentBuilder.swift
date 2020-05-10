import EurofurenceModel
import UIKit

public class CollectThemAllComponentBuilder {

    private var sceneFactory: HybridWebSceneFactory
    private let service: CollectThemAllService

    public init(service: CollectThemAllService) {
        self.service = service
        sceneFactory = StoryboardHybridWebSceneFactory()
    }

    @discardableResult
    public func with(_ sceneFactory: HybridWebSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }

    public func build() -> CollectThemAllComponentFactory {
        CollectThemAllComponentFactoryImpl(sceneFactory: sceneFactory, service: service)
    }

}
