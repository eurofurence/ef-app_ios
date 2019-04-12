@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDealerDetailSceneLoads_DealerDetailPresenterShould: XCTestCase {

    func testTellTheInteractorToMakeViewModelUsingDealerIdentifier() {
        let identifier: DealerIdentifier = .random
        let context = DealerDetailPresenterTestBuilder().build(for: identifier)
        context.simulateSceneDidLoad()

        XCTAssertEqual(identifier, context.interactor.capturedIdentifierForProducingViewModel)
    }

    func testTellTheSceneToBindNumberOfComponentsFromTheViewModelOntoTheScene() {
        let viewModel = FakeDealerDetailViewModel(numberOfComponents: .random)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(viewModel.numberOfComponents, context.scene.boundNumberOfComponents)
    }

}
