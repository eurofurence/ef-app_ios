//
//  WhenFetchingKnowledgeGroupsAfterSuccessfulRefresh.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingKnowledgeGroupsAfterSuccessfulRefresh: XCTestCase {
    
    func testEntriesAreConsolidatedByGroupIdentifierInGroupOrder() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        var expected = syncResponse.knowledgeGroups.changed.map { (group) -> KnowledgeGroup2 in
            let entries = syncResponse.knowledgeEntries.changed.filter({ $0.groupIdentifier == group.identifier }).map { (entry) in
                return KnowledgeEntry2(title: entry.title,
                                       order: entry.order,
                                       contents: entry.text,
                                       links: entry.links.map({ return Link(name: $0.name, type: Link.Kind(rawValue: $0.fragmentType.rawValue)!, contents: $0.target) }).sorted(by: { $0.0.name < $0.1.name }))
            }.sorted(by: { $0.0.order < $0.1.order })
            
            return KnowledgeGroup2(title: group.groupName,
                                   groupDescription: group.groupDescription,
                                   order: group.order,
                                   entries: entries)
        }
        
        expected.sort(by: { $0.0.order < $0.1.order })
        
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let expectedKnowledgeGroupsExpectation = expectation(description: "Expected knowledge groups to be extracted from sync response")
        context.application.fetchKnowledgeGroups { (groups) in
            if expected == groups {
                expectedKnowledgeGroupsExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1)
    }
    
}
