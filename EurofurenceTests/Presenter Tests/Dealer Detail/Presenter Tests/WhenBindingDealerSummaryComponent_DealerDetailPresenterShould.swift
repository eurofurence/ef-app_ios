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
    
    var context: DealerDetailPresenterTestBuilder.Context!
    var summaryViewModel: DealerDetailSummaryViewModel!
    var boundComponent: AnyObject?
    
    override func setUp() {
        super.setUp()
        
        summaryViewModel = DealerDetailSummaryViewModel.random
        let viewModel = FakeDealerDetailSummaryViewModel(summary: summaryViewModel)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
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
    
}
