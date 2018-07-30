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
        private var linkModels: [Link]

        init(contents: NSAttributedString, links: [Link]) {
            self.contents = contents
            self.linkModels = links
            self.links = links.map({ LinkViewModel(name: $0.name) })
        }

        func link(at index: Int) -> Link {
            return linkModels[index]
        }

    }

    var knowledgeService: KnowledgeService = EurofurenceApplication.shared
    var renderer: WikiRenderer = ConcreteWikiRenderer()

    func makeViewModel(for identifier: KnowledgeEntry2.Identifier, completionHandler: @escaping (KnowledgeEntryDetailViewModel) -> Void) {
        knowledgeService.fetchKnowledgeEntry(for: identifier) { (theEntry) in
            let renderedContents = self.renderer.renderContents(from: theEntry.contents)
            completionHandler(ViewModel(contents: renderedContents, links: theEntry.links))
        }
    }

}
