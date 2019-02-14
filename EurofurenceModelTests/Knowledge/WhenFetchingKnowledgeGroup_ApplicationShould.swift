//
//  WhenFetchingKnowledgeGroup_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenFetchingKnowledgeGroup_ApplicationShould: XCTestCase {

    func testReturnOnlyEntriesForThatGroup() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let randomGroup = syncResponse.knowledgeGroups.changed.randomElement()

        var actual: KnowledgeGroup?
        context.knowledgeService.fetchKnowledgeGroup(identifier: KnowledgeGroupIdentifier(randomGroup.element.identifier)) { actual = $0 }

        KnowledgeGroupAssertion().assertGroup(actual,
                                              characterisedByGroup: randomGroup.element,
                                              entries: syncResponse.knowledgeEntries.changed)
    }

}
