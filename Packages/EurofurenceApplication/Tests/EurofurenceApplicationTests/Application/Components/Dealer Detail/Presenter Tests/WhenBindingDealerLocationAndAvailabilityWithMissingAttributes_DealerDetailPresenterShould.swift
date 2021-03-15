import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenBindingDealerLocationAndAvailabilityWithMissingAttributes_DealerDetailPresenterShould: XCTestCase {

    func testHideTheLocationInformation() {
        var locationAndAvailabilityViewModel = DealerDetailLocationAndAvailabilityViewModel.random
        locationAndAvailabilityViewModel.mapPNGGraphicData = nil
        locationAndAvailabilityViewModel.limitedAvailabilityWarning = nil
        locationAndAvailabilityViewModel.locatedInAfterDarkDealersDenMessage = nil
        let viewModel = FakeDealerDetailLocationAndAvailabilityViewModel(location: locationAndAvailabilityViewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        let component = context.boundLocationAndAvailabilityComponent
        XCTAssertEqual(true, component?.didHideMap)
        XCTAssertEqual(true, component?.didHideLimitedAvailbilityWarning)
        XCTAssertEqual(true, component?.didHideAfterDarkDenNotice)
    }

}
