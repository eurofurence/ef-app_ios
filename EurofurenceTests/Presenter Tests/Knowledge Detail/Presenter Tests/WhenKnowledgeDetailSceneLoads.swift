//
//  WhenKnowledgeDetailSceneLoads.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenKnowledgeDetailSceneLoads: XCTestCase {
    
    func testTheKnowledgeEntryFormattedTextIsAppliedOntoScene() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        context.knowledgeDetailScene.simulateSceneDidLoad()
        
        XCTAssertEqual(context.interactor.viewModel.contents, context.knowledgeDetailScene.capturedKnowledgeAttributedText)
    }
    
    func testLinksFromTheKnowledgeEntryAreBoundOntoScene() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        context.knowledgeDetailScene.simulateSceneDidLoad()
        let randomLink = context.interactor.viewModel.links.randomElement()
        let linkScene = CapturingLinkScene()
        context.knowledgeDetailScene.linksBinder?.bind(linkScene, at: randomLink.index)
        
        XCTAssertEqual(context.interactor.viewModel.links.count, context.knowledgeDetailScene.linksToPresent)
        XCTAssertEqual(randomLink.element.name, linkScene.capturedLinkName)
    }
    
    func testTheTitleFromTheViewModelIsBoundOntoTheScene() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        context.knowledgeDetailScene.simulateSceneDidLoad()
        let expected = context.interactor.viewModel.title
        
        XCTAssertEqual(expected, context.knowledgeDetailScene.capturedTitle)
    }
    
}
