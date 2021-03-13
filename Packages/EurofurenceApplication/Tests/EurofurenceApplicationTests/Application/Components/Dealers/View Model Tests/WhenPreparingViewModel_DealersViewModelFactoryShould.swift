import EurofurenceApplication
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
        context.viewModelFactory.makeDealersViewModel { viewModel = $0 }
        delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
    }

    func testUseIndexingStringForGroupsAndIndexTitles() {
        let modelDealers = context.dealersService.index.alphabetisedDealers
        let indexingStrings = modelDealers.map(\.indexingString)

        XCTAssertEqual(indexingStrings, delegate.capturedGroups.map(\.title))
        XCTAssertEqual(indexingStrings, delegate.capturedIndexTitles)
    }

    func testBindDealerNamesOntoViewModel() {
        let modelDealers = context.dealersService.index.alphabetisedDealers
        let randomGroup = modelDealers.randomElement()
        let randomDealer = randomGroup.element.dealers.randomElement()
        let randomDealerIndexPath = IndexPath(item: randomDealer.index, section: randomGroup.index)
        let dealerViewModel = delegate.capturedDealerViewModel(at: randomDealerIndexPath)
        
        XCTAssertEqual(randomDealer.element.preferredName, dealerViewModel?.title)
        XCTAssertEqual(randomDealer.element.alternateName, dealerViewModel?.subtitle)
    }

}
