//
//  KnowledgeEntriesRemoveAllBeforeInsertTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class KnowledgeEntriesRemoveAllBeforeInsertTests: XCTestCase {

    func testTellTheDataStoreToDeleteTheKnowledgeEntries() {
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.knowledgeEntries.removeAllBeforeInsert = true
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)
        let originalEntryIdentifiers = originalResponse.knowledgeEntries.changed.map({ $0.identifier })
        let deletedKnowledgeEntries = context.dataStore.transaction.deletedKnowledgeEntries

        XCTAssertTrue(originalEntryIdentifiers.equalsIgnoringOrder(deletedKnowledgeEntries),
                      "Should have removed original knowledge entries between sync events")
    }

}
