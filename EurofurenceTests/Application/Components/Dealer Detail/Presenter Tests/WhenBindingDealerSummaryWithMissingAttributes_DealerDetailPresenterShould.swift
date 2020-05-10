@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingDealerSummaryWithMissingAttributes_DealerDetailPresenterShould: XCTestCase {

    var context: DealerDetailPresenterTestBuilder.Context!

    override func setUp() {
        super.setUp()

        var summaryViewModel = DealerDetailSummaryViewModel.random
        summaryViewModel.artistImagePNGData = nil
        summaryViewModel.shortDescription = nil
        summaryViewModel.subtitle = nil
        summaryViewModel.telegramHandle = nil
        summaryViewModel.twitterHandle = nil
        summaryViewModel.website = nil
        let viewModel = FakeDealerDetailSummaryViewModel(summary: summaryViewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)
    }

    func testTellTheArtistArtworkToHideWhenArtworkDataNotAvailable() {
        XCTAssertEqual(true, context.boundDealerSummaryComponent?.didHideArtistArtwork)
    }

    func testTellTheSubtitleToHideWhenNoSubtitleNotAvailable() {
        XCTAssertEqual(true, context.boundDealerSummaryComponent?.didHideSubtitle)
    }

    func testTellTheShortDescriptionToHideWhenNoShortDescriptionNotAvailable() {
        XCTAssertEqual(true, context.boundDealerSummaryComponent?.didHideShortDescription)
    }

    func testTellTheTelegramHandleToHideWhenTelegramHandleNotAvailable() {
        XCTAssertEqual(true, context.boundDealerSummaryComponent?.didHideTelegramHandle)
    }

    func testTellTheTwitterHandleToHideWhenTwitterHandleNotAvailable() {
        XCTAssertEqual(true, context.boundDealerSummaryComponent?.didHideTwitterHandle)
    }

    func testTellTheWebsiteToHideWhenWebsiteNotAvailable() {
        XCTAssertEqual(true, context.boundDealerSummaryComponent?.didHideWebsite)
    }

}
