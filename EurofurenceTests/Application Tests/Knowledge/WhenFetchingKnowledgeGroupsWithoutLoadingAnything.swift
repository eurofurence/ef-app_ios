//
//  WhenFetchingKnowledgeGroupsWithoutLoadingAnything.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingKnowledgeGroupsWithoutLoadingAnything: XCTestCase {
    
    func testEmptyGroupsAreReturned() {
        let context = ApplicationTestBuilder().build()
        let emptyGroupsExpectation = expectation(description: "Should have been given empty knowledge groups array")
        context.application.fetchKnowledgeGroups { (groups) in
            if groups.isEmpty {
                emptyGroupsExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.1)
    }
    
}
