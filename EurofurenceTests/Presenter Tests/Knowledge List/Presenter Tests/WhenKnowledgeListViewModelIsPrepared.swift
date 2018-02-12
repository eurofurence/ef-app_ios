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
    
    func testBindingKnowledgeGroupHeadingSetsTitleOntoScene() {
        let context = KnowledgeListPresenterTestBuilder().build()
        context.scene.delegate?.knowledgeListSceneDidLoad()
        let viewModel = StubKnowledgeBaseViewModel.withRandomData()
        context.simulateLoadingViewModel(viewModel)
        let randomGroup = viewModel.randomKnowledgeGroup
        let expected = randomGroup.knowledgeGroup.title
        let scene = CapturingKnowledgeGroupHeaderScene()
        context.scene.bind(scene, toGroupAt: randomGroup.index)
        
        XCTAssertEqual(expected, scene.capturedTitle)
    }
    
}
