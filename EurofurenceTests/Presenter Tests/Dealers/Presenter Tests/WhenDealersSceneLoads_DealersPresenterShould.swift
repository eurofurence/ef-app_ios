@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenDealersSceneLoads_DealersPresenterShould: XCTestCase {

    func testBindTheCountOfDealersPerGroupFromTheViewModelOntoTheScene() {
        let dealerGroups = [DealersGroupViewModel].random
        let viewModel = CapturingDealersViewModel(dealerGroups: dealerGroups)
        let interactor = FakeDealersViewModelFactory(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let expected = dealerGroups.map(\.dealers.count)

        XCTAssertEqual(expected, context.scene.capturedDealersPerSectionToBind)
    }

    func testBindTheSectionIndexTitlesFromTheViewModelOntoTheScene() {
        let viewModel = CapturingDealersViewModel()
        let interactor = FakeDealersViewModelFactory(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(viewModel.sectionIndexTitles, context.scene.capturedSectionIndexTitles)
    }

}
