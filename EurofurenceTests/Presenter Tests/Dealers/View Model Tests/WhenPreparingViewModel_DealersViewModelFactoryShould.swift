@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_DealersViewModelFactoryShould: XCTestCase {

    var context: DealersViewModelTestBuilder.Context!
    var delegate: CapturingDealersViewModelDelegate!

    override func setUp() {
        super.setUp()

        context = DealersViewModelTestBuilder().build()
        var viewModel: DealersViewModel?
        context.interactor.makeDealersViewModel { viewModel = $0 }
        delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
    }

    private func fetchRandomDealerAndAssociatedViewModel() -> (dealer: Dealer, viewModel: DealerViewModel?) {
        let modelDealers = context.dealersService.index.alphabetisedDealers
        let randomGroup = modelDealers.randomElement()
        let randomDealer = randomGroup.element.dealers.randomElement()
        let dealerViewModel = delegate.capturedDealerViewModel(at: IndexPath(item: randomDealer.index, section: randomGroup.index))

        return (dealer: randomDealer.element, viewModel: dealerViewModel)
    }

    func testConvertIndexedDealersIntoExpectedGroupTitles() {
        let modelDealers = context.dealersService.index.alphabetisedDealers
        let expected = modelDealers.map(\.indexingString)
        let actual = delegate.capturedGroups.map(\.title)

        XCTAssertEqual(expected, actual)
    }

    func testProduceIndexTitlesUsingGroupedIndicies() {
        let modelDealers = context.dealersService.index.alphabetisedDealers
        let expected = modelDealers.map(\.indexingString)
        let actual = delegate.capturedIndexTitles

        XCTAssertEqual(expected, actual)
    }

    func testBindPreferredDealerNameOntoDealerViewModelTitle() {
        let context = fetchRandomDealerAndAssociatedViewModel()
        XCTAssertEqual(context.dealer.preferredName, context.viewModel?.title)
    }

    func testBindAlternateDealerNameOntoDealerViewModelSubtitle() {
        let context = fetchRandomDealerAndAssociatedViewModel()
        XCTAssertEqual(context.dealer.alternateName, context.viewModel?.subtitle)
    }

}
