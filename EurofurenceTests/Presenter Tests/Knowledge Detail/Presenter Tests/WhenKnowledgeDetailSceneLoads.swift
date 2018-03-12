//
//  WhenKnowledgeDetailSceneLoads.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import XCTest

class WhenKnowledgeDetailSceneLoads: XCTestCase {
    
    func testTheKnowledgeEntryFormattedTextIsAppliedOntoScene() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        let expected = NSAttributedString(string: .random)
        context.interactor.stub(expected, for: context.knowledgeEntry)
        context.knowledgeDetailScene.simulateSceneDidLoad()
        
        XCTAssertEqual(expected, context.knowledgeDetailScene.capturedKnowledgeAttributedText)
    }
    
}
