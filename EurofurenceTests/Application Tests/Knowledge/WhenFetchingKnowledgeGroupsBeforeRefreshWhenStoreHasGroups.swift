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
        let context = ApplicationTestBuilder().build()
        let persistedGroups: [KnowledgeGroup2] = .random
        let expected = persistedGroups.sorted()
        var actual: [KnowledgeGroup2] = []
        context.dataStore.stubbedKnowledgeGroups = persistedGroups
        context.application.fetchKnowledgeGroups { actual = $0 }
        
        XCTAssertEqual(expected, actual)
    }
    
}
