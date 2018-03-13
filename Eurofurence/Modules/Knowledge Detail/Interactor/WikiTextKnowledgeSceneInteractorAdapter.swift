//
//  WikiTextKnowledgeSceneInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct WikiTextKnowledgeSceneInteractorAdapter: KnowledgeDetailSceneInteractor {

    func makeViewModel(for entry: KnowledgeEntry2) -> KnowledgeEntryDetailViewModel {
        let attributedContents = WikiText.transform(entry.contents)
        return KnowledgeEntryDetailViewModel(contents: attributedContents, links: [])
    }

}
