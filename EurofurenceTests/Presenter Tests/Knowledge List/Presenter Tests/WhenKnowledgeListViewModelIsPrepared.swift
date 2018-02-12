//
//  WhenKnowledgeListViewModelIsPrepared.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenKnowledgeListViewModelIsPrepared: XCTestCase {
    
    func testTheSceneIsToldToHideTheLoadingIndicator() {
        let context = KnowledgeListPresenterTestBuilder().build()
        context.scene.delegate?.knowledgeListSceneDidLoad()
        context.simulateLoadingViewModel()
        
        XCTAssertTrue(context.scene.didHideLoadingIndicator)
    }
    
    func testTheSceneIsToldToDisplayKnowledgeGroups() {
        let context = KnowledgeListPresenterTestBuilder().build()
        context.scene.delegate?.knowledgeListSceneDidLoad()
        let viewModel = StubKnowledgeBaseViewModel.withRandomData()
        context.simulateLoadingViewModel(viewModel)
        let expected = viewModel.groups.map({ $0.entries.count })
        
        XCTAssertEqual(expected, context.scene.capturedEntriesPerGroup)
    }
    
}
