//
//  AnnouncementDetailInteractorTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import Foundation

class AnnouncementDetailInteractorTestBuilder {
    
    struct Context {
        var interactor: AnnouncementDetailInteractor
        var markdownRenderer: StubMarkdownRenderer
        var announcement: Announcement2
        var announcementsService: StubAnnouncementsService
    }
    
    func build(for identifier: Announcement2.Identifier = .random) -> Context {
        var announcement = Announcement2.random
        announcement.identifier = identifier
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
