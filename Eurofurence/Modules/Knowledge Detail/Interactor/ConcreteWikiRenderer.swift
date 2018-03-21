//
//  ConcreteWikiRenderer.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

struct ConcreteWikiRenderer: WikiRenderer {

    func renderContents(from wikiText: String) -> NSAttributedString {
        let text = NSMutableAttributedString(attributedString: WikiText.transform(wikiText))
        text.removeAttribute(NSForegroundColorAttributeName, range: NSMakeRange(0, text.length))

        return text
    }

}
