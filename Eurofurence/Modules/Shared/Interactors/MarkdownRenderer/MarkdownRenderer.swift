import Foundation

protocol MarkdownRenderer {

    func render(_ contents: String) -> NSAttributedString

}
