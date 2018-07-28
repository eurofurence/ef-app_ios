//
//  MarkdownRenderer.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol MarkdownRenderer {

    func render(_ contents: String) -> NSAttributedString

}
