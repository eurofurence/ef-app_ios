//
//  WhenBindingKnowledgeEntry_KnowledgeGroupEntriesPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingKnowledgeEntry_KnowledgeGroupEntriesPresenterShould: XCTestCase {

    func testBindTheNameOfTheEntryOntoTheComponent() {
        let context = KnowledgeGroupEntriesPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        let randomEntry = context.viewModel.entries.randomElement()
        let component = CapturingKnowledgeGroupEntryScene()
        context.bind(component, at: randomEntry.index)

        XCTAssertEqual(randomEntry.element.title, component.capturedTitle)
    }

}
