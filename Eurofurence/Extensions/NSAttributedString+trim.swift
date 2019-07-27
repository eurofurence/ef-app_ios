import Foundation

extension NSAttributedString {
	public func attributedStringByTrimming(with charSet: CharacterSet) -> NSAttributedString {
		let mutableString = NSMutableAttributedString(attributedString: self)
		mutableString.trim(using: charSet)
		return NSAttributedString(attributedString: mutableString)
	}
}
