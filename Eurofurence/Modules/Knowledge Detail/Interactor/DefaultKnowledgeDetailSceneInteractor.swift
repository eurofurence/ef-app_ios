//
//  DefaultKnowledgeDetailSceneInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DefaultKnowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor {

    private struct ViewModel: KnowledgeEntryDetailViewModel {

        var contents: NSAttributedString
        var links: [LinkViewModel]

    }

    var knowledgeService: KnowledgeService = EurofurenceApplication.shared
    var renderer: WikiRenderer = ConcreteWikiRenderer()

    func makeViewModel(for identifier: KnowledgeEntry2.Identifier, completionHandler: @escaping (KnowledgeEntryDetailViewModel) -> Void) {
        knowledgeService.fetchKnowledgeEntry(for: identifier) { (theEntry) in
            let renderedContents = self.renderer.renderContents(from: theEntry.contents)
            let linkViewModels = theEntry.links.map(self.makeLinkViewModel)

            completionHandler(ViewModel(contents: renderedContents, links: linkViewModels))
        }
    }

    private func makeLinkViewModel(from link: Link) -> LinkViewModel {
        return LinkViewModel(name: link.name)
    }

}
