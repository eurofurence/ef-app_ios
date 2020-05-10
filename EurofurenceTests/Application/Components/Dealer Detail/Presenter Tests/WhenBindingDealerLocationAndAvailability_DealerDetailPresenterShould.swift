@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingDealerLocationAndAvailability_DealerDetailPresenterShould: XCTestCase {

    func testBindTheProducedMapGraphicFromTheViewModelOntoTheComponent() {
        let locationAndAvailabilityViewModel = DealerDetailLocationAndAvailabilityViewModel.random
        let viewModel = FakeDealerDetailLocationAndAvailabilityViewModel(location: locationAndAvailabilityViewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        XCTAssertEqual(locationAndAvailabilityViewModel.mapPNGGraphicData, context.boundLocationAndAvailabilityComponent?.capturedMapPNGGraphicData)
    }

    func testBindTheLimitedAvailabilityWarningFromTheViewModelOntoTheComponent() {
        let locationAndAvailabilityViewModel = DealerDetailLocationAndAvailabilityViewModel.random
        let viewModel = FakeDealerDetailLocationAndAvailabilityViewModel(location: locationAndAvailabilityViewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        XCTAssertEqual(locationAndAvailabilityViewModel.limitedAvailabilityWarning, context.boundLocationAndAvailabilityComponent?.capturedLimitedAvailabilityWarning)
    }

    func testBindTheLocatedInAfterDarkDealersDenNoticeOntoTheComponent() {
        let locationAndAvailabilityViewModel = DealerDetailLocationAndAvailabilityViewModel.random
        let viewModel = FakeDealerDetailLocationAndAvailabilityViewModel(location: locationAndAvailabilityViewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        let expected = locationAndAvailabilityViewModel.locatedInAfterDarkDealersDenMessage
        let actual = context.boundLocationAndAvailabilityComponent?.capturedLocatedInAfterDarkDealersDenMessage
        XCTAssertEqual(expected, actual)
    }

    func testBindTheLocationAndAvailabilityTitleOntoTheComponent() {
        let locationAndAvailabilityViewModel = DealerDetailLocationAndAvailabilityViewModel.random
        let viewModel = FakeDealerDetailLocationAndAvailabilityViewModel(location: locationAndAvailabilityViewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        XCTAssertEqual(locationAndAvailabilityViewModel.title, context.boundLocationAndAvailabilityComponent?.capturedTitle)
    }

}
