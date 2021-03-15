import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenDealersSceneLoads_DealersPresenterShould: XCTestCase {

    func testBindTheDealersAndIndexTitles() {
        let dealerGroups = [DealersGroupViewModel].random
        let viewModel = CapturingDealersViewModel(dealerGroups: dealerGroups)
        let viewModelFactory = FakeDealersViewModelFactory(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let expected = dealerGroups.map(\.dealers.count)

        XCTAssertEqual(expected, context.scene.capturedDealersPerSectionToBind)
        XCTAssertEqual(viewModel.sectionIndexTitles, context.scene.capturedSectionIndexTitles)
    }

}
