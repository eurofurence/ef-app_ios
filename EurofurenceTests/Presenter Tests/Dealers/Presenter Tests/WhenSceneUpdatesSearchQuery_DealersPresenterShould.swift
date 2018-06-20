//
//  WhenSceneUpdatesSearchQuery_DealersPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenSceneUpdatesSearchQuery_DealersPresenterShould: XCTestCase {
    
    func testTellTheSearchableViewModelToUpdateItsResults() {
        let searchViewModel = CapturingDealersSearchViewModel()
        let interactor = FakeDealersInteractor(searchViewModel: searchViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let query = String.random
        context.simulateSceneDidChangeSearchQuery(to: query)
        
        XCTAssertEqual(query, searchViewModel.capturedSearchQuery)
    }
    
}
