@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingDealerLocationAndAvailabilityWithMissingAttributes_DealerDetailPresenterShould: XCTestCase {

    func testTellTheComponentToHideTheMap() {
        var locationAndAvailabilityViewModel = DealerDetailLocationAndAvailabilityViewModel.random
        locationAndAvailabilityViewModel.mapPNGGraphicData = nil
        locationAndAvailabilityViewModel.limitedAvailabilityWarning = nil
        locationAndAvailabilityViewModel.locatedInAfterDarkDealersDenMessage = nil
        let viewModel = FakeDealerDetailLocationAndAvailabilityViewModel(location: locationAndAvailabilityViewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        XCTAssertEqual(true, context.boundLocationAndAvailabilityComponent?.didHideMap)
    }

    func testTellTheComponentToHideTheLimitedAvailabilityWarning() {
        var locationAndAvailabilityViewModel = DealerDetailLocationAndAvailabilityViewModel.random
        locationAndAvailabilityViewModel.mapPNGGraphicData = nil
        locationAndAvailabilityViewModel.limitedAvailabilityWarning = nil
        locationAndAvailabilityViewModel.locatedInAfterDarkDealersDenMessage = nil
        let viewModel = FakeDealerDetailLocationAndAvailabilityViewModel(location: locationAndAvailabilityViewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        XCTAssertEqual(true, context.boundLocationAndAvailabilityComponent?.didHideLimitedAvailbilityWarning)
    }

    func testTellTheComponentToHideTheAfterDarkDenNotice() {
        var locationAndAvailabilityViewModel = DealerDetailLocationAndAvailabilityViewModel.random
        locationAndAvailabilityViewModel.mapPNGGraphicData = nil
        locationAndAvailabilityViewModel.limitedAvailabilityWarning = nil
        locationAndAvailabilityViewModel.locatedInAfterDarkDealersDenMessage = nil
        let viewModel = FakeDealerDetailLocationAndAvailabilityViewModel(location: locationAndAvailabilityViewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        XCTAssertEqual(true, context.boundLocationAndAvailabilityComponent?.didHideAfterDarkDenNotice)
    }

}
