//
//  DefaultAnnouncementDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class DefaultAnnouncementDetailInteractorShould: XCTestCase {

    var context: AnnouncementDetailInteractorTestBuilder.Context!

    override func setUp() {
        super.setUp()
        context = AnnouncementDetailInteractorTestBuilder().build()
    }

    func testProduceViewModelUsingAnnouncementTitleAsHeading() {
        let viewModel = context.makeViewModel()
        XCTAssertEqual(context.announcement.title, viewModel?.heading)
    }

    func testProduceViewModelContentsUsingMarkdownRenderer() {
        let viewModel = context.makeViewModel()
        XCTAssertEqual(context.markdownRenderer.stubbedContents(for: context.announcement.content), viewModel?.contents)
    }

    func testProduceViewModelWithAnnouncementImage() {
        let viewModel = context.makeViewModel()
        let announcementIdentifier = context.announcement.identifier
        let expected = context.announcementsService.stubbedAnnouncementImageData(for: announcementIdentifier)

        XCTAssertEqual(expected, viewModel?.imagePNGData)
    }

}
