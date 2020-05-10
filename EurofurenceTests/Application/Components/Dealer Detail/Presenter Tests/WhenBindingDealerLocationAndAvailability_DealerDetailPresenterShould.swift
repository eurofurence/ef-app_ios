import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingDealerLocationAndAvailability_DealerDetailPresenterShould: XCTestCase {

    func testBindTheArtistLocationAndAvailabilityInformation() {
        let locationAndAvailabilityViewModel = DealerDetailLocationAndAvailabilityViewModel.random
        let viewModel = FakeDealerDetailLocationAndAvailabilityViewModel(location: locationAndAvailabilityViewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        let component = context.boundLocationAndAvailabilityComponent
        
        XCTAssertEqual(locationAndAvailabilityViewModel.mapPNGGraphicData, component?.capturedMapPNGGraphicData)
        XCTAssertEqual(locationAndAvailabilityViewModel.limitedAvailabilityWarning, component?.capturedLimitedAvailabilityWarning)
        XCTAssertEqual(locationAndAvailabilityViewModel.title, component?.capturedTitle)
        XCTAssertEqual(locationAndAvailabilityViewModel.locatedInAfterDarkDealersDenMessage, component?.capturedLocatedInAfterDarkDealersDenMessage)
    }

}
