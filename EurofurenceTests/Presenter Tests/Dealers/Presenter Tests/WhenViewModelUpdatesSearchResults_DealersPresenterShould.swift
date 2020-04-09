@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenViewModelUpdatesSearchResults_DealersPresenterShould: XCTestCase {

    func testBindTheCountOfDealersPerGroupFromTheViewModelOntoTheScene() {
        let dealerGroups = [DealersGroupViewModel].random
        let searchViewModel = CapturingDealersSearchViewModel(dealerGroups: dealerGroups)
        let interactor = FakeDealersInteractor(searchViewModel: searchViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let expected = dealerGroups.map(\.dealers.count)

        XCTAssertEqual(expected, context.scene.capturedDealersPerSectionToBindToSearchResults)
    }

    func testBindTheSectionIndexTitlesFromTheViewModelOntoTheScene() {
        let searchViewModel = CapturingDealersSearchViewModel()
        let interactor = FakeDealersInteractor(searchViewModel: searchViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()

        XCTAssertEqual(searchViewModel.sectionIndexTitles, context.scene.capturedSectionIndexTitlesToBindToSearchResults)
    }

}
