import Eurofurence
import EurofurenceModel
import UIKit

class MapsPresenterTestBuilder {

    struct Context {
        var scene: CapturingMapsScene
        var producedViewController: UIViewController
        var delegate: CapturingMapsComponentDelegate
    }

    private var viewModelFactory: MapsViewModelFactory

    init() {
        viewModelFactory = FakeMapsViewModelFactory()
    }

    @discardableResult
    func with(_ viewModelFactory: MapsViewModelFactory) -> MapsPresenterTestBuilder {
        self.viewModelFactory = viewModelFactory
        return self
    }

    func build() -> Context {
        let sceneFactory = StubMapsSceneFactory()
        let delegate = CapturingMapsComponentDelegate()
        let module = MapsComponentBuilder(mapsViewModelFactory: viewModelFactory)
            .with(sceneFactory)
            .build()
            .makeMapsModule(delegate)

        return Context(scene: sceneFactory.scene,
                       producedViewController: module,
                       delegate: delegate)
    }

}

extension MapsPresenterTestBuilder.Context {

    func simulateSceneDidLoad() {
        scene.delegate?.mapsSceneDidLoad()
    }

    func simulateSceneDidSelectMap(at index: Int) {
        scene.delegate?.simulateSceneDidSelectMap(at: index)
    }

    func bindMap(at index: Int) -> CapturingMapComponent {
        let component = CapturingMapComponent()
        scene.binder?.bind(component, at: index)
        return component
    }

}
