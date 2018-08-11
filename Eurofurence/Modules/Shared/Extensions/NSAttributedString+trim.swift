//
//  NSAttributedString+trim.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 26/07/18.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension NSAttributedString {
	public func attributedStringByTrimming(with charSet: CharacterSet) -> NSAttributedString {
		let mutableString = NSMutableAttributedString(attributedString: self)
		mutableString.trim(using: charSet)
		return NSAttributedString(attributedString: mutableString)
	}
}
