@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenFetchingIdentifierForSearchResult_DealersInteractorShould: XCTestCase {

    func testProvideTheIdentifierForTheDealer() {
        let dealersService = FakeDealersService()
        let context = DealerInteractorTestBuilder().with(dealersService).build()
        var viewModel: DealersSearchViewModel?
        context.interactor.makeDealersSearchViewModel { viewModel = $0 }
        let modelDealers = dealersService.index.alphabetisedDealersSearchResult
        let randomGroup = modelDealers.randomElement()
        let randomDealer = randomGroup.element.dealers.randomElement()
        let expected = randomDealer.element.identifier
        let indexPath = IndexPath(item: randomDealer.index, section: randomGroup.index)
        let actual = viewModel?.identifierForDealer(at: indexPath)

        XCTAssertEqual(expected, actual)
    }

}
