//
//  WikiTextKnowledgeSceneInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct WikiTextKnowledgeSceneInteractorAdapter: KnowledgeDetailSceneInteractor {

    func makeContents(for entry: KnowledgeEntry2) -> NSAttributedString {
        return WikiText.transform(entry.contents)
    }

}
