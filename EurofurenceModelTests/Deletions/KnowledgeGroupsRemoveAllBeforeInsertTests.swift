//
//  KnowledgeGroupsRemoveAllBeforeInsertTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class KnowledgeGroupsRemoveAllBeforeInsertTests: XCTestCase {

    func testTellTheDataStoreToDeleteTheKnowledgeGroups() {
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.knowledgeGroups.removeAllBeforeInsert = true
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)

        XCTAssertEqual(subsequentResponse.knowledgeGroups.changed,
                       context.dataStore.fetchKnowledgeGroups(),
                       "Should have removed original groups between sync events")
    }

}
