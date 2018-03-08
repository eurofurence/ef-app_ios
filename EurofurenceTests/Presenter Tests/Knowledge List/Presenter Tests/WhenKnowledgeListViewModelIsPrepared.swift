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
    var viewModel: KnowledgeListViewModel!
    
    override func setUp() {
        super.setUp()
        
        context = KnowledgeListPresenterTestBuilder().build()
        context.scene.delegate?.knowledgeListSceneDidLoad()
        viewModel = .random
        context.simulateLoadingViewModel(viewModel)
    }
    
    func testTheSceneIsToldToHideTheLoadingIndicator() {
        XCTAssertTrue(context.scene.didHideLoadingIndicator)
    }
    
    func testTheSceneIsToldToDisplayKnowledgeGroups() {
        let expected = viewModel.knowledgeGroups.map({ $0.knowledgeEntries.count })
        XCTAssertEqual(expected, context.scene.capturedEntriesPerGroup)
    }
    
    func testBindingKnowledgeGroupHeadingSetsTitleOntoScene() {
        let randomGroup = viewModel.knowledgeGroups.randomElement()
        let expected = randomGroup.element.title
        let scene = CapturingKnowledgeGroupHeaderScene()
        context.scene.bind(scene, toGroupAt: randomGroup.index)
        
        XCTAssertEqual(expected, scene.capturedTitle)
    }
    
    func testBindingKnowledgeGroupHeadingSetsIconOntoScene() {
        let randomGroup = viewModel.knowledgeGroups.randomElement()
        let expected = randomGroup.element.icon
        let scene = CapturingKnowledgeGroupHeaderScene()
        context.scene.bind(scene, toGroupAt: randomGroup.index)
        
        XCTAssertEqual(expected, scene.capturedIcon)
    }
    
    func testBindingKnowledgeGroupHeadingSetsDescriptionOntoScene() {
        let randomGroup = viewModel.knowledgeGroups.randomElement()
        let expected = randomGroup.element.groupDescription
        let scene = CapturingKnowledgeGroupHeaderScene()
        context.scene.bind(scene, toGroupAt: randomGroup.index)
        
        XCTAssertEqual(expected, scene.capturedGroupDescription)
    }
    
    func testBindingKnowledgeGroupEntrySetsTitleOntoScene() {
        let randomGroup = viewModel.knowledgeGroups.randomElement()
        let randomEntry = randomGroup.element.knowledgeEntries.randomElement()
        let expected = randomEntry.element.title
        let scene = CapturingKnowledgeGroupEntryScene()
        context.scene.bind(scene, toEntryInGroup: randomGroup.index, at: randomEntry.index)
        
        XCTAssertEqual(expected, scene.capturedTitle)
    }
    
    func testSelectingKnowledgeEntryTellsDelegateToPresentSelectedViewModel() {
        let randomGroup = viewModel.knowledgeGroups.randomElement()
        let randomEntry = randomGroup.element.knowledgeEntries.randomElement()
        let expected = randomEntry.element
        context.scene.simulateSelectingKnowledgeEntry(inGroup: randomGroup.index, at: randomEntry.index)
        
        XCTAssertEqual(expected, context.delegate.capturedKnowledgeEntryToPresent)
    }
    
    func testSelectingKnowledgeEntryTellsSceneToDeselectSelectedItem() {
        let randomGroup = viewModel.knowledgeGroups.randomElement()
        let randomEntry = randomGroup.element.knowledgeEntries.randomElement()
        context.scene.simulateSelectingKnowledgeEntry(inGroup: randomGroup.index, at: randomEntry.index)
        let expected = IndexPath(item: randomEntry.index, section: randomGroup.index)
        
        XCTAssertEqual(expected, context.scene.deselectedIndexPath)
    }
    
}
