@testable import Eurofurence
import EurofurenceModel
import Foundation

class StubMarkdownRenderer: MarkdownRenderer {

    private var producedContents = [String: NSAttributedString]()

    func render(_ contents: String) -> NSAttributedString {
        let renderedContents = NSAttributedString.random
        producedContents[contents] = renderedContents

        return renderedContents
    }

    func stubbedContents(for contents: String) -> NSAttributedString {
        return producedContents[contents] ?? .random
    }

}
