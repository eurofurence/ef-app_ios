//
//  InOrderToSupportSyncKnowledgeListLoading_KnowledgeListPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class InOrderToSupportSyncKnowledgeListLoading_KnowledgeListPresenterShould: XCTestCase {
    
    func testShowTheLoadingIndicatorBeforeRequestingViewModelToBePrepared() {
        let context = KnowledgeListPresenterTestBuilder().build()
        context.knowledgeInteractor.prepareViewModelInvokedHandler = {
            XCTAssertTrue(context.scene.didShowLoadingIndicator)
        }
        
        context.scene.delegate?.knowledgeListSceneDidLoad()
    }
    
}
