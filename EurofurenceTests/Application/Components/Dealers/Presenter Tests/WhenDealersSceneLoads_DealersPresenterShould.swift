@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenDealersSceneLoads_DealersPresenterShould: XCTestCase {

    func testBindTheCountOfDealersPerGroupFromTheViewModelOntoTheScene() {
        let dealerGroups = [DealersGroupViewModel].random
        let viewModel = CapturingDealersViewModel(dealerGroups: dealerGroups)
        let viewModelFactory = FakeDealersViewModelFactory(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let expected = dealerGroups.map(\.dealers.count)

        XCTAssertEqual(expected, context.scene.capturedDealersPerSectionToBind)
    }

    func testBindTheSectionIndexTitlesFromTheViewModelOntoTheScene() {
        let viewModel = CapturingDealersViewModel()
        let viewModelFactory = FakeDealersViewModelFactory(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(viewModel.sectionIndexTitles, context.scene.capturedSectionIndexTitles)
    }

}
