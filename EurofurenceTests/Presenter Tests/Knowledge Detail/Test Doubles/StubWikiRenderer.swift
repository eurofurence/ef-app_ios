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
    
    private(set) var stubbedEntryContents = [String : NSAttributedString]()
    func renderContents(from wikiText: String) -> NSAttributedString {
        let entry = NSAttributedString.random
        stubbedEntryContents[wikiText] = entry
        
        return entry
    }
    
}
