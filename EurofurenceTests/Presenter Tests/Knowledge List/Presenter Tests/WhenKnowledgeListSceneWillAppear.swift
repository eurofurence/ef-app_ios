//
//  WhenKnowledgeListSceneWillAppear.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenKnowledgeListSceneWillAppear: XCTestCase {
    
    func testWhenTheViewWillAppearTheInteractorIsToldToPrepareKnowledgeListViewModel() {
        let context = KnowledgeListPresenterTestBuilder().build()
        context.scene.delegate?.knowledgeListSceneWillAppear()
        
        XCTAssertTrue(context.knowledgeInteractor.toldToPrepareViewModel)
    }
    
    func testTheSceneIsToldToShowTheLoadingIndicator() {
        let context = KnowledgeListPresenterTestBuilder().build()
        context.scene.delegate?.knowledgeListSceneWillAppear()
        
        XCTAssertTrue(context.scene.didShowLoadingIndicator)
    }
    
}
