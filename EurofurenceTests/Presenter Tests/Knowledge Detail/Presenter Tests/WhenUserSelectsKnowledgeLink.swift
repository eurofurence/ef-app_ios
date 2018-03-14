//
//  WhenUserSelectsKnowledgeLink.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenUserSelectsKnowledgeLink: XCTestCase {
    
    func testTheSceneIsToldToDeselectTheLink() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        context.knowledgeDetailScene.simulateSceneDidLoad()
        let randomLink = context.interactor.viewModel.links.randomElement()
        context.knowledgeDetailScene.simulateSelectingLink(at: randomLink.index)
        
        XCTAssertEqual(randomLink.index, context.knowledgeDetailScene.deselectedLinkIndex)
    }
    
    func testTheDelegateIsToldToOpenTheChosenLink() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        context.knowledgeDetailScene.simulateSceneDidLoad()
        let expected = Link.random
        let randomLink = context.interactor.viewModel.links.randomElement()
        context.interactor.stub(expected, at: randomLink.index)
        context.knowledgeDetailScene.simulateSelectingLink(at: randomLink.index)
        
        XCTAssertEqual(expected, context.delegate.capturedLinkToOpen)
    }
    
}
