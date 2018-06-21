//
//  WhenBindingDealerSummaryComponent_DealerDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingDealerSummaryComponent_DealerDetailPresenterShould: XCTestCase {
    
    func testSetTheArtistImageOntoTheComponent() {
        let dealerSummaryViewModel = DealerDetailSummaryViewModel.random
        let viewModel = FakeDealerDetailSummaryViewModel(summary: dealerSummaryViewModel)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)
        
        XCTAssertEqual(dealerSummaryViewModel.artistImagePNGData, context.boundDealerSummaryComponent?.capturedArtistImagePNGData)
    }
    
    func testReturnTheBoundComponentBackToTheScene() {
        let dealerSummaryViewModel = DealerDetailSummaryViewModel.random
        let viewModel = FakeDealerDetailSummaryViewModel(summary: dealerSummaryViewModel)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let boundComponent = context.bindComponent(at: 0)
        
        XCTAssertTrue(boundComponent === context.boundDealerSummaryComponent)
    }
    
    func testSetTheDealerTitleOntoTheComponent() {
        let dealerSummaryViewModel = DealerDetailSummaryViewModel.random
        let viewModel = FakeDealerDetailSummaryViewModel(summary: dealerSummaryViewModel)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)
        
        XCTAssertEqual(dealerSummaryViewModel.title, context.boundDealerSummaryComponent?.capturedDealerTitle)
    }
    
}
