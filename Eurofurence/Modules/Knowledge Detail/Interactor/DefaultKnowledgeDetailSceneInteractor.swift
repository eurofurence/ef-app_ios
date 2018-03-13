//
//  DefaultKnowledgeDetailSceneInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DefaultKnowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor {

    var renderer: WikiRenderer = ConcreteWikiRenderer()

    func makeViewModel(for entry: KnowledgeEntry2) -> KnowledgeEntryDetailViewModel {
        let renderedContents = renderer.renderContents(from: entry.contents)
        let linkViewModels = entry.links.map(makeLinkViewModel)

        return KnowledgeEntryDetailViewModel(contents: renderedContents, links: linkViewModels)
    }

    private func makeLinkViewModel(from link: Link) -> LinkViewModel {
        return LinkViewModel(name: link.name)
    }

}
