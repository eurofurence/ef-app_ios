//
//  WhenFetchingKnowledgeGroupsBeforeRefreshWhenStoreHasGroups.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingKnowledgeGroupsBeforeRefreshWhenStoreHasGroups: XCTestCase {
    
    func testTheGroupsFromTheStoreAreAdaptedInOrder() {
        let dataStore = CapturingEurofurenceDataStore()
        let knowledge = APIKnowledgeGroup.makeRandomGroupsAndEntries()
        dataStore.performTransaction { (transaction) in
            transaction.saveKnowledgeGroups(knowledge.groups)
            transaction.saveKnowledgeEntries(knowledge.entries)
        }
        
        let context = ApplicationTestBuilder().with(dataStore).build()
        
        let expected = knowledge.groups.map({ (group) -> KnowledgeGroup2 in
            let entries = knowledge.entries.filter({ $0.groupIdentifier == group.identifier }).map(KnowledgeEntry2.fromServerModel).sorted()
            
            return KnowledgeGroup2(identifier: KnowledgeGroup2.Identifier(group.identifier),
                                   title: group.groupName,
                                   groupDescription: group.groupDescription,
                                   order: group.order,
                                   entries: entries)
        }).sorted()
        
        var actual: [KnowledgeGroup2] = []
        context.application.fetchKnowledgeGroups { actual = $0 }
        
        XCTAssertEqual(expected, actual)
    }
    
}
