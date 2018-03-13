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
    
}
