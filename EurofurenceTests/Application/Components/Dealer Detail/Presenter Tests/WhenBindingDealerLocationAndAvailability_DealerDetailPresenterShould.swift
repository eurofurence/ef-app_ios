import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingDealerLocationAndAvailability_DealerDetailPresenterShould: XCTestCase {

    func testBindTheArtistLocationAndAvailabilityInformation() {
        let viewModel = DealerDetailLocationAndAvailabilityViewModel.random
        let viewModelWrapper = FakeDealerDetailLocationAndAvailabilityViewModel(location: viewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModelWrapper)
        let context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        let component = context.boundLocationAndAvailabilityComponent
        
        XCTAssertEqual(viewModel.mapPNGGraphicData, component?.capturedMapPNGGraphicData)
        XCTAssertEqual(viewModel.limitedAvailabilityWarning, component?.capturedLimitedAvailabilityWarning)
        XCTAssertEqual(viewModel.title, component?.capturedTitle)
        XCTAssertEqual(
            viewModel.locatedInAfterDarkDealersDenMessage,
            component?.capturedLocatedInAfterDarkDealersDenMessage
        )
    }

}
