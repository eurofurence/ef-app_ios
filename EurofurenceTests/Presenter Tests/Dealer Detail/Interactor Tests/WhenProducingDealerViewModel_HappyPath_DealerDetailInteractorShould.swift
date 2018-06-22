//
//  WhenProducingDealerViewModel_HappyPath_DealerDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenProducingDealerViewModel_HappyPath_DealerDetailInteractorShould: XCTestCase {
    
    func testProduceExpectedNumberOfComponents() {
        let dealersService = FakeDealersService()
        let interactor = DefaultDealerDetailInteractor(dealersService: dealersService)
        var viewModel: DealerDetailViewModel?
        interactor.makeDealerDetailViewModel(for: .random) { viewModel = $0 }
        
        XCTAssertEqual(4, viewModel?.numberOfComponents)
    }
    
    func testProduceExpectedSummaryAtIndexZero() {
        let dealersService = FakeDealersService()
        let interactor = DefaultDealerDetailInteractor(dealersService: dealersService)
        var viewModel: DealerDetailViewModel?
        let identifier = Dealer2.Identifier.random
        interactor.makeDealerDetailViewModel(for: identifier) { viewModel = $0 }
        let dealerData = dealersService.fakedDealerData(for: identifier)
        let expected = DealerDetailSummaryViewModel(artistImagePNGData: dealerData.artistImagePNGData,
                                                    title: dealerData.preferredName,
                                                    subtitle: dealerData.alternateName,
                                                    categories: dealerData.categories.joined(separator: ", "),
                                                    shortDescription: dealerData.dealerShortDescription,
                                                    website: dealerData.websiteName,
                                                    twitterHandle: dealerData.twitterUsername,
                                                    telegramHandle: dealerData.telegramUsername)
        let visitor = CapturingDealerDetailViewModelVisitor()
        viewModel?.describeComponent(at: 0, to: visitor)
        
        XCTAssertEqual(expected, visitor.visitedSummary)
    }
    
}
