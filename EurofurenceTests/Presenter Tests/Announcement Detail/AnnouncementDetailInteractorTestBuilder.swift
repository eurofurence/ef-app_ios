//
//  AnnouncementDetailInteractorTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class AnnouncementDetailInteractorTestBuilder {

    struct Context {
        var interactor: AnnouncementDetailInteractor
        var markdownRenderer: StubMarkdownRenderer
        var announcement: StubAnnouncement
        var announcementsService: StubAnnouncementsService
    }
    
    private var imagePNGData: Data?
    
    func with(imagePNGData: Data) -> AnnouncementDetailInteractorTestBuilder {
        self.imagePNGData = imagePNGData
        return self
    }

    func build(for identifier: AnnouncementIdentifier = .random) -> Context {
        let announcement = StubAnnouncement.random
        announcement.identifier = identifier
        announcement.imagePNGData = imagePNGData
        let announcementsService = StubAnnouncementsService(announcements: [announcement])
        let markdownRenderer = StubMarkdownRenderer()
        let interactor = DefaultAnnouncementDetailInteractor(announcementsService: announcementsService,
                                                             markdownRenderer: markdownRenderer)

        return Context(interactor: interactor,
                       markdownRenderer: markdownRenderer,
                       announcement: announcement,
                       announcementsService: announcementsService)
    }

}

extension AnnouncementDetailInteractorTestBuilder.Context {

    func makeViewModel() -> AnnouncementViewModel? {
        var viewModel: AnnouncementViewModel?
        interactor.makeViewModel(for: announcement.identifier) { viewModel = $0 }

        return viewModel
    }

}
