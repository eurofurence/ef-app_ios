//
//  WhenSceneSelectsKnowledgeEntry_KnowledgeGroupEntriesPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenSceneSelectsKnowledgeEntry_KnowledgeGroupEntriesPresenterShould: XCTestCase {

    func testTellTheDelegateAboutTheSelectedEntryIdentifier() {
        let context = KnowledgeGroupEntriesPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        let randomEntry = context.viewModel.entries.randomElement()
        context.simulateSceneDidSelectEntry(at: randomEntry.index)
        let expected = context.viewModel.identifierForKnowledgeEntry(at: randomEntry.index)

        XCTAssertEqual(expected, context.delegate.selectedKnowledgeEntryIdentifier)
    }

}
