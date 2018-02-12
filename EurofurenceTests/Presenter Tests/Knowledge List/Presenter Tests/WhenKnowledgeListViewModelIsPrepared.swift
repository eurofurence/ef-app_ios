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
    
    var context: KnowledgeListPresenterTestBuilder.Context!
    var viewModel: StubKnowledgeBaseViewModel!
    
    override func setUp() {
        super.setUp()
        
        context = KnowledgeListPresenterTestBuilder().build()
        context.scene.delegate?.knowledgeListSceneDidLoad()
        viewModel = StubKnowledgeBaseViewModel.withRandomData()
        context.simulateLoadingViewModel(viewModel)
    }
    
    func testTheSceneIsToldToHideTheLoadingIndicator() {
        XCTAssertTrue(context.scene.didHideLoadingIndicator)
    }
    
    func testTheSceneIsToldToDisplayKnowledgeGroups() {
        let expected = viewModel.groups.map({ $0.entries.count })
        XCTAssertEqual(expected, context.scene.capturedEntriesPerGroup)
    }
    
    func testBindingKnowledgeGroupHeadingSetsTitleOntoScene() {
        let randomGroup = viewModel.randomKnowledgeGroup
        let expected = randomGroup.knowledgeGroup.title
        let scene = CapturingKnowledgeGroupHeaderScene()
        context.scene.bind(scene, toGroupAt: randomGroup.index)
        
        XCTAssertEqual(expected, scene.capturedTitle)
    }
    
    func testBindingKnowledgeGroupEntrySetsTitleOntoScene() {
        let randomGroup = viewModel.randomKnowledgeGroup
        let randomEntry = randomGroup.knowledgeGroup.randomEntry
        let expected = randomEntry.knowledgeEntry.title
        let scene = CapturingKnowledgeGroupEntryScene()
        context.scene.bind(scene, toEntryInGroup: randomGroup.index, at: randomEntry.index)
        
        XCTAssertEqual(expected, scene.capturedTitle)
    }
    
}
