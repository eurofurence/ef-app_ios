//
//  WhenShowingKnowledgeEntryWithoutLinks.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenShowingKnowledgeEntryWithoutLinks: XCTestCase {
    
    func testTheSceneIsNotToldToShowLinks() {
        let interactor = StubKnowledgeDetailSceneInteractor()
        interactor.viewModel = .randomWithoutLinks
        let context = KnowledgeDetailPresenterTestBuilder().with(interactor).build()
        context.knowledgeDetailScene.simulateSceneDidLoad()
        
        XCTAssertNil(context.knowledgeDetailScene.linksToPresent)
    }
    
}
