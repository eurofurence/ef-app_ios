import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingDealerSummaryWithMissingAttributes_DealerDetailPresenterShould: XCTestCase {

    func testHideAllInformation() {
        var summaryViewModel = DealerDetailSummaryViewModel.random
        summaryViewModel.artistImagePNGData = nil
        summaryViewModel.shortDescription = nil
        summaryViewModel.subtitle = nil
        summaryViewModel.telegramHandle = nil
        summaryViewModel.twitterHandle = nil
        summaryViewModel.website = nil
        let viewModel = FakeDealerDetailSummaryViewModel(summary: summaryViewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)
        
        XCTAssertEqual(true, context.boundDealerSummaryComponent?.didHideArtistArtwork)
        XCTAssertEqual(true, context.boundDealerSummaryComponent?.didHideSubtitle)
        XCTAssertEqual(true, context.boundDealerSummaryComponent?.didHideShortDescription)
        XCTAssertEqual(true, context.boundDealerSummaryComponent?.didHideTelegramHandle)
        XCTAssertEqual(true, context.boundDealerSummaryComponent?.didHideTwitterHandle)
        XCTAssertEqual(true, context.boundDealerSummaryComponent?.didHideWebsite)
    }

}
