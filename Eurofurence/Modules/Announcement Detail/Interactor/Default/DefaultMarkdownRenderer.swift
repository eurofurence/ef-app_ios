//
//  DefaultMarkdownRenderer.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DefaultMarkdownRenderer: MarkdownRenderer {

    func render(_ contents: String) -> NSAttributedString {
        return NSAttributedString(string: contents)
    }

}
