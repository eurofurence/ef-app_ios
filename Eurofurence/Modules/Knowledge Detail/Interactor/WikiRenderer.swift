//
//  WikiRenderer.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol WikiRenderer {

    func renderContents(from wikiText: String) -> NSAttributedString

}
