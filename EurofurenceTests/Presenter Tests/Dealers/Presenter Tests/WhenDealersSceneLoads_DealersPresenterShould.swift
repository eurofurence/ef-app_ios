//
//  WhenDealersSceneLoads_DealersPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenDealersSceneLoads_DealersPresenterShould: XCTestCase {
    
    func testBindTheCountOfDealersPerGroupFromTheViewModelOntoTheScene() {
        let dealerGroups = [DealersGroupViewModel].random
        let viewModel = CapturingDealersViewModel(dealerGroups: dealerGroups)
        let interactor = FakeDealersInteractor(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let expected = dealerGroups.map { $0.dealers.count }
        
        XCTAssertEqual(expected, context.scene.capturedDealersPerSectionToBind)
    }
    
    func testBindTheSectionIndexTitlesFromTheViewModelOntoTheScene() {
        let viewModel = CapturingDealersViewModel()
        let interactor = FakeDealersInteractor(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(viewModel.sectionIndexTitles, context.scene.capturedSectionIndexTitles)
    }
    
}
