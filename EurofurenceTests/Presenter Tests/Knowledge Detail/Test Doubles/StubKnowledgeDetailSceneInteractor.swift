//
//  StubKnowledgeDetailSceneInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class StubKnowledgeDetailSceneInteractor: KnowledgeDetailSceneInteractor {
    
    fileprivate var contentsByEntry = [KnowledgeEntry2 : NSAttributedString]()
    func makeContents(for entry: KnowledgeEntry2) -> NSAttributedString {
        return contentsByEntry[entry] ?? NSAttributedString()
    }
    
}

extension StubKnowledgeDetailSceneInteractor {
    
    func stub(_ contents: NSAttributedString, for entry: KnowledgeEntry2) {
        contentsByEntry[entry] = contents
    }
    
}
