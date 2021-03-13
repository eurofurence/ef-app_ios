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
