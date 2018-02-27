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
    
    func testTheGroupsFromTheStoreAreAdapted() {
        let context = ApplicationTestBuilder().build()
        let expected: [KnowledgeGroup2] = .random
        var actual: [KnowledgeGroup2] = []
        context.dataStore.stubbedKnowledgeGroups = expected
        context.application.fetchKnowledgeGroups { actual = $0 }
        
        XCTAssertEqual(expected, actual)
    }
    
}
