import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDealerDetailSceneLoads_DealerDetailPresenterShould: XCTestCase {

    func testTellTheViewModelFactoryToMakeViewModelUsingDealerIdentifier() {
        let identifier: DealerIdentifier = .random
        let context = DealerDetailPresenterTestBuilder().build(for: identifier)
        context.simulateSceneDidLoad()

        XCTAssertEqual(identifier, context.viewModelFactory.capturedIdentifierForProducingViewModel)
    }

    func testTellTheSceneToBindNumberOfComponentsFromTheViewModelOntoTheScene() {
        let viewModel = FakeDealerDetailViewModel(numberOfComponents: .random)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(viewModel.numberOfComponents, context.scene.boundNumberOfComponents)
    }
    
    func testRecordTheUserWitnessedTheDealer() {
        let identifier: DealerIdentifier = .random
        let context = DealerDetailPresenterTestBuilder().build(for: identifier)
        
        XCTAssertNil(context.dealerInteractionRecorder.witnessedDealer)
        
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(context.dealerInteractionRecorder.witnessedDealer, identifier)
    }

}
