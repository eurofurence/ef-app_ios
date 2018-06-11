//
//  WikiText.swift
//  Eurofurence
//
//  Based on code ported to Swift from C# code by Luchs
//  Source: https://github.com/eurofurence/ef-app_wp/blob/master/Eurofurence.Companion/ViewModel/Converter/WikiTextToHtmlConverter.cs
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

class WikiText {
    private static let _regexListItems = try! NSRegularExpression(pattern: "\\n  \\* ([^\\n]*)", options: [])
    private static let _regexBold = try! NSRegularExpression(pattern: "\\*\\*([^\\*]*)\\*\\*", options: [])
    private static let _regexItalic = try! NSRegularExpression(pattern: "\\*([^\\*\\n]*)\\*", options: [])

    static func transform(_ wikiText: String, style: String = "") -> NSAttributedString {
        guard !wikiText.isEmpty else {
			return NSAttributedString()
		}
		let mutableText = NSMutableString(string: wikiText)
		mutableText.replaceOccurrences(of: "\\\\", with: "", options: [], range: NSRange(location: 0, length: mutableText.length))
		WikiText._regexListItems.replaceMatches(in: mutableText, options: [], range: NSRange(location: 0, length: mutableText.length), withTemplate: "\n  • $1")

		let attributes = [
			NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body),
			NSAttributedStringKey.foregroundColor: UIColor.lightText
		]
		let attributedString = NSMutableAttributedString(string: mutableText as String, attributes: attributes)

		if let boldFontDescriptor = UIFont.preferredFont(forTextStyle: .body).fontDescriptor.withSymbolicTraits(.traitBold) {
			let boldFont = UIFont(descriptor: boldFontDescriptor, size: 0)
            let attributes = [NSAttributedStringKey.font: boldFont]
			attributedString.apply(regex: _regexBold, attributes: attributes, captureGroup: 1)
		}

		if let italicFontDescriptor = UIFont.preferredFont(forTextStyle: .body).fontDescriptor.withSymbolicTraits(.traitItalic) {
			let italicFont = UIFont(descriptor: italicFontDescriptor, size: 0)
			let attributes = [NSAttributedStringKey.font: italicFont]
			attributedString.apply(regex: _regexItalic, attributes: attributes, captureGroup: 1)
		}

		return attributedString
    }

}

extension NSMutableAttributedString {

	/// Applies the given attributes to every match of the regular expression
	/// and replaces the entire match with the content of the capture group at
	/// the given index.
	///
	/// - Parameters:
	///   - regex: regular expression to be matched against the string
	///   - attributes: attributes to be applied to matches
	///   - captureGroup: capture group containing the replacement
	func apply(regex: NSRegularExpression, attributes: [NSAttributedStringKey: Any], captureGroup: Int = 0) {
		var rangeOffset: Int = 0
		regex.matches(in: mutableString as String, options: [], range: NSRange(location: 0, length: mutableString.length)).forEach({ (result) in

			let replacementRange = NSRange(location: result.range(at: captureGroup).location - rangeOffset, length: result.range(at: captureGroup).length)
			let replacementString = mutableString.substring(with: replacementRange)

			let offsetRange = NSRange(location: result.range.location - rangeOffset, length: result.range.length)
			addAttributes(attributes, range: offsetRange)
			replaceCharacters(in: offsetRange, with: replacementString)

			rangeOffset += result.range.length - replacementString.characters.count
		})
	}
}
