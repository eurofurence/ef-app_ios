//
//  AnnouncementDetailInteractorTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class AnnouncementDetailInteractorTestBuilder {
    
    struct Context {
        var interactor: AnnouncementDetailInteractor
        var markdownRenderer: StubMarkdownRenderer
        var announcement: Announcement2
    }
    
    func build() -> Context {
        let markdownRenderer = StubMarkdownRenderer()
        let factory = DefaultAnnouncementDetailInteractorFactory(markdownRenderer: markdownRenderer)
        let announcement = Announcement2.random
        let interactor = factory.makeAnnouncementDetailInteractor(for: announcement)
        
        return Context(interactor: interactor,
                       markdownRenderer: markdownRenderer,
                       announcement: announcement)
    }
    
}

extension AnnouncementDetailInteractorTestBuilder.Context {
    
    func makeViewModel() -> AnnouncementViewModel? {
        var viewModel: AnnouncementViewModel?
        interactor.makeViewModel { viewModel = $0 }
        
        return viewModel
    }
    
}
