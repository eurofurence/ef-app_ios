//
//  DefaultAnnouncementDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class DefaultAnnouncementDetailInteractorShould: XCTestCase {
    
    var interactor: AnnouncementDetailInteractor!
    var markdownRenderer: StubMarkdownRenderer!
    var announcement: Announcement2!
    
    override func setUp() {
        super.setUp()
        
        markdownRenderer = StubMarkdownRenderer()
        let factory = DefaultAnnouncementDetailInteractorFactory(markdownRenderer: markdownRenderer)
        announcement = Announcement2.random
        interactor = factory.makeAnnouncementDetailInteractor(for: announcement)
    }
    
    func testProduceViewModelUsingAnnouncementTitleAsHeading() {
        let viewModel = makeViewModel()
        XCTAssertEqual(announcement.title, viewModel?.heading)
    }
    
    func testProduceViewModelContentsUsingMarkdownRenderer() {
        let viewModel = makeViewModel()
        XCTAssertEqual(markdownRenderer.stubbedContents(for: announcement.content), viewModel?.contents)
    }
    
    private func makeViewModel() -> AnnouncementViewModel? {
        var viewModel: AnnouncementViewModel?
        interactor.makeViewModel { viewModel = $0 }
        
        return viewModel
    }
    
}
