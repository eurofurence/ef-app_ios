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
        let interactor = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        boundComponent = context.bindComponent(at: 0)
    }

    func testSetTheArtistImageOntoTheComponent() {
        XCTAssertEqual(summaryViewModel.artistImagePNGData, context.boundDealerSummaryComponent?.capturedArtistImagePNGData)
    }

    func testReturnTheBoundComponentBackToTheScene() {
        XCTAssertTrue(boundComponent === context.boundDealerSummaryComponent)
    }

    func testSetTheDealerTitleOntoTheComponent() {
        XCTAssertEqual(summaryViewModel.title, context.boundDealerSummaryComponent?.capturedDealerTitle)
    }

    func testSetTheDealerSubtitleOntoTheComponent() {
        XCTAssertEqual(summaryViewModel.subtitle, context.boundDealerSummaryComponent?.capturedDealerSubtitle)
    }

    func testSetTheDealerCategoriesOntoTheComponent() {
        XCTAssertEqual(summaryViewModel.categories, context.boundDealerSummaryComponent?.capturedDealerCategories)
    }

    func testSetTheDealerShortDescriptionOntoTheComponent() {
        XCTAssertEqual(summaryViewModel.shortDescription, context.boundDealerSummaryComponent?.capturedDealerShortDescription)
    }

    func testSetTheDealerWebsiteOntoTheComponent() {
        XCTAssertEqual(summaryViewModel.website, context.boundDealerSummaryComponent?.capturedDealerWebsite)
    }

    func testSetTheDealerTwitterHandleOntoTheComponent() {
        XCTAssertEqual(summaryViewModel.twitterHandle, context.boundDealerSummaryComponent?.capturedDealerTwitterHandle)
    }

    func testSetTheDealerTelegramHandleOntoTheComponent() {
        XCTAssertEqual(summaryViewModel.telegramHandle, context.boundDealerSummaryComponent?.capturedDealerTelegramHandle)
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
