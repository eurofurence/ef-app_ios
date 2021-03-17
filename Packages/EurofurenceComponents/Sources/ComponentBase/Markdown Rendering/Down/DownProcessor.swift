import Down
import Foundation

struct DownProcessor {
    
    let styler: Styler
    
    func convertMarkdownToAttributedString(markdown: String) -> NSAttributedString {
        do {
            let down = Down(markdownString: markdown)
            let attributedString = try down.toAttributedString(DownOptions.smart, styler: styler)
            return attributedString.attributedStringByTrimming(with: CharacterSet.whitespacesAndNewlines)
        } catch {
            return NSAttributedString(string: markdown)
        }
    }
    
}

private extension NSAttributedString {
    
    func attributedStringByTrimming(with charSet: CharacterSet) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(attributedString: self)
        mutableString.trim(using: charSet)
        return NSAttributedString(attributedString: mutableString)
    }
    
}

private extension NSMutableAttributedString {
    func trim(using charSet: CharacterSet) {
        var range = (string as NSString).rangeOfCharacter(from: charSet)

        // Trim leading characters from character set.
        while range.length != 0 && range.location == 0 {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet)
        }

        // Trim trailing characters from character set.
        range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
        while range.length != 0 && NSMaxRange(range) == length {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
        }
    }
}
