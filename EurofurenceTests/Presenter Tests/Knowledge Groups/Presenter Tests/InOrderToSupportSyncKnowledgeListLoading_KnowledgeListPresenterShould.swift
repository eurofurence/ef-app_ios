//
//  InOrderToSupportSyncKnowledgeListLoading_KnowledgeGroupsListPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class InOrderToSupportSyncKnowledgeListLoading_KnowledgeGroupsListPresenterShould: XCTestCase {

    func testShowTheLoadingIndicatorBeforeRequestingViewModelToBePrepared() {
        let context = KnowledgeGroupsPresenterTestBuilder().build()
        context.knowledgeInteractor.prepareViewModelInvokedHandler = {
            XCTAssertTrue(context.scene.didShowLoadingIndicator)
        }

        context.scene.delegate?.knowledgeListSceneDidLoad()
    }

}
