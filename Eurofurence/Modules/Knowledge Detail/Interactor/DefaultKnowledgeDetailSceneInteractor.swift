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
        return KnowledgeEntryDetailViewModel(contents: renderedContents, links: [])
    }

}
