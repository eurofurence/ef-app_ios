import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit

class CapturingMapDetailComponentDelegate: MapDetailComponentDelegate {

    private(set) var capturedDealerToShow: DealerIdentifier?
    func mapDetailModuleDidSelectDealer(_ identifier: DealerIdentifier) {
        capturedDealerToShow = identifier
    }

}

class MapDetailPresenterTestBuilder {

    struct Context {
        var scene: CapturingMapDetailScene
        var producedViewController: UIViewController
        var delegate: CapturingMapDetailComponentDelegate
    }

    private var viewModelFactory: MapDetailViewModelFactory

    init() {
        viewModelFactory = FakeMapDetailViewModelFactory()
    }

    @discardableResult
    func with(_ viewModelFactory: MapDetailViewModelFactory) -> MapDetailPresenterTestBuilder {
        self.viewModelFactory = viewModelFactory
        return self
    }

    func build(for identifier: MapIdentifier = .random) -> Context {
        let sceneFactory = StubMapDetailSceneFactory()
        let delegate = CapturingMapDetailComponentDelegate()
        let module = MapDetailComponentBuilder(mapDetailViewModelFactory: viewModelFactory)
            .with(sceneFactory)
            .build()
            .makeMapDetailComponent(for: identifier, delegate: delegate)

        return Context(scene: sceneFactory.scene, producedViewController: module, delegate: delegate)
    }

}

extension MapDetailPresenterTestBuilder.Context {

    func simulateSceneDidLoad() {
        scene.delegate?.mapDetailSceneDidLoad()
    }

    func simulateSceneDidDidTapMap(at location: MapCoordinate) {
        scene.delegate?.mapDetailSceneDidTapMap(at: location)
    }

    func simulateSceneTappedMapOption(at index: Int) {
        scene.mapOptionSelectionHandler?(index)
    }

}
