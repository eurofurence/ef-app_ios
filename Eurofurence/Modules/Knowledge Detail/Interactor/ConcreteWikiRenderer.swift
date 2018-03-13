//
//  ConcreteWikiRenderer.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct ConcreteWikiRenderer: WikiRenderer {

    func renderContents(from wikiText: String) -> NSAttributedString {
        return WikiText.transform(wikiText)
    }

}
