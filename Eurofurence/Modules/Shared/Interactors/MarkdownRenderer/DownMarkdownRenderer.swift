//
//  DownMarkdownRenderer.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 26/07/18.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import Down

protocol DownMarkdownRenderer: MarkdownRenderer {
	var stylesheet: String? { get }
}

extension DownMarkdownRenderer {
	func render(_ contents: String) -> NSAttributedString {
		let down = Down(markdownString: contents)
		do {
			let attributedString = try down.toAttributedString(DownOptions.smart, stylesheet: stylesheet)
			return attributedString.attributedStringByTrimming(with: CharacterSet.whitespacesAndNewlines)
		} catch {
			return NSAttributedString(string: contents)
		}
	}

}
