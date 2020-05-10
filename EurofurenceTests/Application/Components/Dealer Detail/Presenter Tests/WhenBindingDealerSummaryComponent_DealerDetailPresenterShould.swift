@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingDealerSummaryComponent_DealerDetailPresenterShould: XCTestCase {

    var context: DealerDetailPresenterTestBuilder.Context!
    var viewModel: FakeDealerDetailViewModel!
    var summaryViewModel: DealerDetailSummaryViewModel!
    var boundComponent: AnyObject?

    override func setUp() {
        super.setUp()

        summaryViewModel = DealerDetailSummaryViewModel.random
        viewModel = FakeDealerDetailSummaryViewModel(summary: summaryViewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        boundComponent = context.bindComponent(at: 0)
    }
    
    func testReturnTheBoundComponentBackToTheScene() {
        XCTAssertTrue(boundComponent === context.boundDealerSummaryComponent)
    }

    func testBindTheSummaryInformation() {
        let component = context.boundDealerSummaryComponent
        XCTAssertEqual(summaryViewModel.artistImagePNGData, component?.capturedArtistImagePNGData)
        XCTAssertEqual(summaryViewModel.title, component?.capturedDealerTitle)
        XCTAssertEqual(summaryViewModel.subtitle, component?.capturedDealerSubtitle)
        XCTAssertEqual(summaryViewModel.categories, component?.capturedDealerCategories)
        XCTAssertEqual(summaryViewModel.shortDescription, component?.capturedDealerShortDescription)
        XCTAssertEqual(summaryViewModel.website, component?.capturedDealerWebsite)
        XCTAssertEqual(summaryViewModel.twitterHandle, component?.capturedDealerTwitterHandle)
        XCTAssertEqual(summaryViewModel.telegramHandle, component?.capturedDealerTelegramHandle)
    }

    func testTellTheViewModelToOpenTheWebsiteLinkWhenItIsSelected() {
        context.boundDealerSummaryComponent?.capturedOnWebsiteSelected?()
        XCTAssertTrue(viewModel.toldToOpenWebsite)
    }

    func testTellTheViewModelToOpenTheTwitterLinkWhenItIsSelected() {
        context.boundDealerSummaryComponent?.capturedOnTwitterSelected?()
        XCTAssertTrue(viewModel.toldToOpenTwitter)
    }

    func testTellTheViewModelToOpenTheTelegramLinkWhenItIsSelected() {
        context.boundDealerSummaryComponent?.capturedOnTelegramSelected?()
        XCTAssertTrue(viewModel.toldToOpenTelegram)
    }

}
