//
//  WhenBuildingKnowledgeGroupEntriesModule.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBuildingKnowledgeGroupEntriesModule: XCTestCase {

    func testTheSceneFromTheFactoryIsReturned() {
        let context = KnowledgeGroupEntriesPresenterTestBuilder().build()
        XCTAssertEqual(context.viewController, context.sceneFactory.scene)
    }

}
