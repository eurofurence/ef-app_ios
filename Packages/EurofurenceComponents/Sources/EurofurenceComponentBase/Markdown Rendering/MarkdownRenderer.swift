import Foundation

public protocol MarkdownRenderer {

    func render(_ contents: String) -> NSAttributedString

}
