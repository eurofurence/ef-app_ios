//
//  ApplicationDirectorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class ApplicationDirectorTests: XCTestCase {
    
    var context: ApplicationDirectorTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = ApplicationDirectorTestBuilder().build()
    }
    
    func testWhenKnowledgeEntrySelectsWebLinkTheWebModuleIsPresentedOntoTheTabInterface() {
        context.navigateToTabController()
        let entry = KnowledgeEntry2.random
        context.knowledgeListModule.simulateKnowledgeGroupSelected(.random)
        context.knowledgeGroupEntriesModule.simulateKnowledgeEntrySelected(.random)
        let link = entry.links.randomElement().element
        let url = URL.random
        context.linkRouter.stubbedLinkActions[link] = .web(url)
        context.knowledgeDetailModule.simulateLinkSelected(link)
        let webModuleForURL = context.webModuleProviding.producedWebModules[url]
        
        XCTAssertNotNil(webModuleForURL)
        XCTAssertEqual(webModuleForURL, context.tabModule.stubInterface.capturedPresentedViewController)
    }
    
    func testWhenKnowledgeEntrySelectsExternalAppLinkTheURLLauncherIsToldToHandleTheURL() {
        context.navigateToTabController()
        let entry = KnowledgeEntry2.random
        context.knowledgeListModule.simulateKnowledgeGroupSelected(.random)
        context.knowledgeGroupEntriesModule.simulateKnowledgeEntrySelected(.random)
        let link = entry.links.randomElement().element
        let url = URL.random
        context.linkRouter.stubbedLinkActions[link] = .externalURL(url)
        context.knowledgeDetailModule.simulateLinkSelected(link)
        
        XCTAssertEqual(url, context.urlOpener.capturedURLToOpen)
    }
    
}
