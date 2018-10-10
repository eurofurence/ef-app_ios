//
//  WhenSelectingKnowledgeGroup_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenSelectingKnowledgeGroup_DirectorShould: XCTestCase {
    
    func testShowTheGroupEntriesModuleOntoTheKnowledgeNavigationController() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let knowledgeNavigationController = context.navigationController(for: context.knowledgeListModule.stubInterface)
        let identifier = KnowledgeGroup.Identifier.random
        context.knowledgeListModule.simulateKnowledgeGroupSelected(identifier)
        
        XCTAssertEqual(context.knowledgeGroupEntriesModule.stubInterface, knowledgeNavigationController?.topViewController)
        XCTAssertEqual(identifier, context.knowledgeGroupEntriesModule.capturedModel)
    }
    
}
