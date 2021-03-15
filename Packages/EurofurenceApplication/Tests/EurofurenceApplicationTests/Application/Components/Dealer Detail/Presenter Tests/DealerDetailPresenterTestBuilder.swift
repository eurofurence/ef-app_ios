import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation
import UIKit

class DealerDetailPresenterTestBuilder {

    struct Context {
        var producedModuleViewController: UIViewController
        var scene: CapturingDealerDetailScene
        var viewModelFactory: FakeDealerDetailViewModelFactory
        var dealerInteractionRecorder: CapturingDealerInteractionRecorder
    }

    private var viewModelFactory: FakeDealerDetailViewModelFactory

    init() {
        viewModelFactory = FakeDealerDetailViewModelFactory()
    }

    @discardableResult
    func with(_ viewModelFactory: FakeDealerDetailViewModelFactory) -> DealerDetailPresenterTestBuilder {
        self.viewModelFactory = viewModelFactory
        return self
    }
    
    func build(for identifier: DealerIdentifier = .random) -> Context {
        let sceneFactory = StubDealerDetailSceneFactory()
        let dealerInteractionRecorder = CapturingDealerInteractionRecorder()
        let module = DealerDetailComponentBuilder(
            dealerDetailViewModelFactory: viewModelFactory,
            dealerInteractionRecorder: dealerInteractionRecorder
        )
        .with(sceneFactory)
        .build()
        .makeDealerDetailComponent(for: identifier)
        
        return Context(
            producedModuleViewController: module,
            scene: sceneFactory.scene,
            viewModelFactory: viewModelFactory,
            dealerInteractionRecorder: dealerInteractionRecorder
        )
    }
    
}

extension DealerDetailPresenterTestBuilder.Context {

    func simulateSceneDidLoad() {
        scene.delegate?.dealerDetailSceneDidLoad()
    }
    
    func simulateSceneDidAppear() {
        scene.delegate?.dealerDetailSceneDidAppear()
    }
    
    func simulateSceneDidDisappear() {
        scene.delegate?.dealerDetailSceneDidDisappear()
    }

    @discardableResult
    func bindComponent(at index: Int) -> CapturingDealerDetailScene.Component? {
        return scene.bindComponent(at: index)
    }

    var boundDealerSummaryComponent: CapturingDealerDetailSummaryComponent? {
        return scene.boundDealerSummaryComponent
    }

    var boundLocationAndAvailabilityComponent: CapturingDealerLocationAndAvailabilityComponent? {
        return scene.boundLocationAndAvailabilityComponent
    }

    var boundAboutTheArtistComponent: CapturingAboutTheArtistComponent? {
        return scene.boundAboutTheArtistComponent
    }

    var boundAboutTheArtComponent: CapturingAboutTheArtComponent? {
        return scene.boundAboutTheArtComponent
    }

}
