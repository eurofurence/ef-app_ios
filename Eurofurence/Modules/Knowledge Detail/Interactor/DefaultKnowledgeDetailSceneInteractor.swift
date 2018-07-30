//
//  DefaultKnowledgeDetailSceneInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DefaultKnowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor {

    var knowledgeService: KnowledgeService = EurofurenceApplication.shared
    var renderer: WikiRenderer = ConcreteWikiRenderer()

    func makeViewModel(for entry: KnowledgeEntry2, completionHandler: @escaping (KnowledgeEntryDetailViewModel) -> Void) {
        knowledgeService.fetchKnowledgeEntry(for: entry.identifier) { (theEntry) in
            let renderedContents = self.renderer.renderContents(from: theEntry.contents)
            let linkViewModels = theEntry.links.map(self.makeLinkViewModel)

            completionHandler(KnowledgeEntryDetailViewModel(contents: renderedContents, links: linkViewModels))
        }
    }

    private func makeLinkViewModel(from link: Link) -> LinkViewModel {
        return LinkViewModel(name: link.name)
    }

}
