//
//  WhenFetchingKnowledgeEntryByIdentifier_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenFetchingKnowledgeEntryByIdentifier_ApplicationShould: XCTestCase {

    func testReturnTheSpecifiedEntry() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let randomEntry = syncResponse.knowledgeEntries.changed.randomElement().element
        var actual: KnowledgeEntry?
        context.knowledgeService.fetchKnowledgeEntry(for: KnowledgeEntryIdentifier(randomEntry.identifier)) { actual = $0 }

        KnowledgeEntryAssertion().assertEntry(actual, characteristics: randomEntry)
    }

}
