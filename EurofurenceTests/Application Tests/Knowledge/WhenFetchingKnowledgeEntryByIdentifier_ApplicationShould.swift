//
//  WhenFetchingKnowledgeEntryByIdentifier_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingKnowledgeEntryByIdentifier_ApplicationShould: XCTestCase {
    
    func testReturnTheSpecifiedEntry() {
        let syncResponse = APISyncResponse.randomWithoutDeletions
        let context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let randomEntry = syncResponse.knowledgeEntries.changed.randomElement().element
        let expected =  KnowledgeEntry2(identifier: KnowledgeEntry2.Identifier(randomEntry.identifier),
                                        title: randomEntry.title,
                                        order: randomEntry.order,
                                        contents: randomEntry.text,
                                        links: randomEntry.links.map({ return Link(name: $0.name, type: Link.Kind(rawValue: $0.fragmentType.rawValue)!, contents: $0.target) }).sorted(by: { $0.name < $1.name }))
        var actual: KnowledgeEntry2?
        context.application.fetchKnowledgeEntry(for: KnowledgeEntry2.Identifier(randomEntry.identifier)) { actual = $0 }
        
        XCTAssertEqual(expected, actual)
    }
    
}
