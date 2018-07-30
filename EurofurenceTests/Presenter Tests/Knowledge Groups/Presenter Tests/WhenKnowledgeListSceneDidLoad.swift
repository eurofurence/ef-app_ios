//
//  WhenKnowledgeListSceneWillAppear.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenKnowledgeListSceneDidLoad: XCTestCase {
    
    var context: KnowledgeGroupsPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = KnowledgeGroupsPresenterTestBuilder().build()
        context.scene.delegate?.knowledgeListSceneDidLoad()
    }
    
    func testWhenTheViewWillAppearTheInteractorIsToldToPrepareKnowledgeGroupsListViewModel() {
        XCTAssertTrue(context.knowledgeInteractor.toldToPrepareViewModel)
    }
    
    func testTheSceneIsToldToShowTheLoadingIndicator() {
        XCTAssertTrue(context.scene.didShowLoadingIndicator)
    }
    
}
