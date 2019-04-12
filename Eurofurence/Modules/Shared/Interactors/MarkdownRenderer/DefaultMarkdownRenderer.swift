import Foundation

struct DefaultMarkdownRenderer: MarkdownRenderer {

    func render(_ contents: String) -> NSAttributedString {
        return NSAttributedString(string: contents)
    }

}
