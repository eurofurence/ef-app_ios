//
//  WhenFetchingKnowledgeGroupsWithoutLoadingAnything.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenFetchingKnowledgeGroupsWithoutLoadingAnything: XCTestCase {

    func testEmptyGroupsAreReturned() {
        let context = ApplicationTestBuilder().build()
        let observer = CapturingKnowledgeServiceObserver()
        context.knowledgeService.add(observer)

        XCTAssertTrue(observer.wasProvidedWithEmptyGroups)
    }

}
