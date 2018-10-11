//
//  WhenBindingDealerSummaryWithMissingAttributes_DealerDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
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
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        context = DealerDetailPresenterTestBuilder().with(interactor).build()
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
