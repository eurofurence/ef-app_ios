//
//  StubWikiRenderer.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class StubWikiRenderer: WikiRenderer {
    
    fileprivate var stubbedEntryContents = [String : NSAttributedString]()
    func renderContents(from wikiText: String) -> NSAttributedString {
        return stubbedEntryContents[wikiText] ?? NSAttributedString()
    }
    
}

extension StubWikiRenderer {
    
    func stub(_ entry: KnowledgeEntry2, with: NSAttributedString) {
        stubbedEntryContents[entry.contents] = with
    }
    
}
