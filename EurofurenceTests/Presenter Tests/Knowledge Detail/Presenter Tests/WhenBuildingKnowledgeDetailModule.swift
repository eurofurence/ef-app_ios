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
        let knowledgeDetailSceneFactory = StubKnowledgeDetailSceneFactory()
        let knowledgeDetailScene = knowledgeDetailSceneFactory.interface
        let context = KnowledgeDetailModuleBuilder().with(knowledgeDetailSceneFactory).build()
        let module = context.makeKnowledgeListModule(.random)
        
        XCTAssertEqual(knowledgeDetailScene, module)
    }
    
    func testTheKnowledgeEntryTitleIsSetAsTheSceneTitle() {
        let knowledgeEntryViewModel = KnowledgeEntryViewModel.random
        let knowledgeDetailSceneFactory = StubKnowledgeDetailSceneFactory()
        let knowledgeDetailScene = knowledgeDetailSceneFactory.interface
        let context = KnowledgeDetailModuleBuilder().with(knowledgeDetailSceneFactory).build()
        _ = context.makeKnowledgeListModule(knowledgeEntryViewModel)
        
        XCTAssertEqual(knowledgeDetailScene.capturedTitle, knowledgeEntryViewModel.title)
    }
    
}
