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
    
    func testTheDelegateIsToldToOpenTheChosenLink() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        context.knowledgeDetailScene.simulateSceneDidLoad()
        let randomLink = context.interactor.viewModel.modelLinks.randomElement()
        let expected = context.interactor.viewModel.link(at: randomLink.index)
        context.knowledgeDetailScene.simulateSelectingLink(at: randomLink.index)
        
        XCTAssertEqual(expected, context.delegate.capturedLinkToOpen)
    }
    
}
