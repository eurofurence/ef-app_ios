@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation
import UIKit

class DealerDetailPresenterTestBuilder {

    struct Context {
        var producedModuleViewController: UIViewController
        var scene: CapturingDealerDetailScene
        var interactor: FakeDealerDetailInteractor
        var dealerInteractionRecorder: CapturingDealerInteractionRecorder
    }

    private var interactor: FakeDealerDetailInteractor

    init() {
        interactor = FakeDealerDetailInteractor()
    }

    @discardableResult
    func with(_ interactor: FakeDealerDetailInteractor) -> DealerDetailPresenterTestBuilder {
        self.interactor = interactor
        return self
    }

    func build(for identifier: DealerIdentifier = .random) -> Context {
        let sceneFactory = StubDealerDetailSceneFactory()
        let dealerInteractionRecorder = CapturingDealerInteractionRecorder()
        let module = DealerDetailModuleBuilder(dealerDetailInteractor: interactor, dealerInteractionRecorder: dealerInteractionRecorder)
            .with(sceneFactory)
            .build()
            .makeDealerDetailModule(for: identifier)

        return Context(producedModuleViewController: module,
                       scene: sceneFactory.scene,
                       interactor: interactor,
                       dealerInteractionRecorder: dealerInteractionRecorder)
    }

}

extension DealerDetailPresenterTestBuilder.Context {

    func simulateSceneDidLoad() {
        scene.delegate?.dealerDetailSceneDidLoad()
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
