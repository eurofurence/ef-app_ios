//
//  WhenBuildingKnowledgeDetailModule.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBuildingKnowledgeDetailModule: XCTestCase {
    
    func testTheSceneFromTheFactoryIsReturned() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        XCTAssertEqual(context.knowledgeDetailScene, context.module)
    }
    
    func testTheKnowledgeEntryTitleIsSetAsTheSceneTitle() {
        let context = KnowledgeDetailPresenterTestBuilder().build()
        XCTAssertEqual(context.knowledgeDetailScene.capturedTitle, context.knowledgeEntry.title)
    }
    
}
