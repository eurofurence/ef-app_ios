//
//  DownMarkdownRenderer.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 26/07/18.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import Down

struct DownMarkdownRenderer: MarkdownRenderer {

	func render(_ contents: String) -> NSAttributedString {
		let down = Down(markdownString: contents)
		do {
			return try down.toAttributedString()
		} catch {
			return NSAttributedString(string: contents)
		}
	}

}
