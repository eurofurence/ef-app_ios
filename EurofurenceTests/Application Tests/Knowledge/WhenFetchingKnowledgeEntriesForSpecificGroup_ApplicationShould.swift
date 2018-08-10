//
//  WhenFetchingKnowledgeEntriesForSpecificGroup_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingKnowledgeEntriesForSpecificGroup_ApplicationShould: XCTestCase {
    
    func testReturnOnlyEntriesForThatGroup() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let context = ApplicationTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let randomGroup = syncResponse.knowledgeGroups.changed.randomElement()
        let expected = syncResponse.knowledgeEntries.changed.filter({ $0.groupIdentifier == randomGroup.element.identifier }).map ({ (entry) -> KnowledgeEntry2 in
            return KnowledgeEntry2(identifier: KnowledgeEntry2.Identifier(entry.identifier),
                                   title: entry.title,
                                   order: entry.order,
                                   contents: entry.text,
                                   links: entry.links.map({ return Link(name: $0.name, type: Link.Kind(rawValue: $0.fragmentType.rawValue)!, contents: $0.target) }).sorted(by: { $0.name < $1.name }))
        }).sorted()
        
        var actual: [KnowledgeEntry2]?
        context.application.fetchKnowledgeEntriesForGroup(identifier: KnowledgeGroup2.Identifier(randomGroup.element.identifier)) { actual = $0 }
        
        XCTAssertEqual(true, actual?.contains(elementsFrom: expected))
    }
    
}
