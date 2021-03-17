import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenFetchingIdentifierForSearchResult_DealersViewModelFactoryShould: XCTestCase {

    func testProvideTheIdentifierForTheDealer() {
        let dealersService = FakeDealersService()
        let context = DealersViewModelTestBuilder().with(dealersService).build()
        var viewModel: DealersSearchViewModel?
        context.viewModelFactory.makeDealersSearchViewModel { viewModel = $0 }
        let modelDealers = dealersService.index.alphabetisedDealersSearchResult
        let randomGroup = modelDealers.randomElement()
        let randomDealer = randomGroup.element.dealers.randomElement()
        let expected = randomDealer.element.identifier
        let indexPath = IndexPath(item: randomDealer.index, section: randomGroup.index)
        let actual = viewModel?.identifierForDealer(at: indexPath)

        XCTAssertEqual(expected, actual)
    }

}
