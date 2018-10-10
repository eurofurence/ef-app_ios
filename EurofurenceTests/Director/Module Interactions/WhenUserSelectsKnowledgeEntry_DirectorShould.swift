//
//  WhenUserSelectsKnowledgeEntry_DirectorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenUserSelectsKnowledgeEntry_DirectorShould: XCTestCase {
    
    func testShowTheKnowledgeEntryModuleForTheChosenEntry() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        context.knowledgeListModule.simulateKnowledgeGroupSelected(.random)
        let knowledgeNavigationController = context.navigationController(for: context.knowledgeListModule.stubInterface)
        let entry = KnowledgeEntry.Identifier.random
        context.knowledgeGroupEntriesModule.simulateKnowledgeEntrySelected(entry)
        
        XCTAssertEqual(context.knowledgeDetailModule.stubInterface, knowledgeNavigationController?.topViewController)
        XCTAssertEqual(entry, context.knowledgeDetailModule.capturedModel)
    }
    
}
