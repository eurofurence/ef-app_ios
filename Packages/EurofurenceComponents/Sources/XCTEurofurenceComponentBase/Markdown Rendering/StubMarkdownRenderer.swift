import EurofurenceComponentBase
import EurofurenceModel
import Foundation
import TestUtilities

public class StubMarkdownRenderer: MarkdownRenderer {

    private var producedContents = [String: NSAttributedString]()
    
    public init() {
        
    }

    public func render(_ contents: String) -> NSAttributedString {
        let renderedContents = NSAttributedString.random
        producedContents[contents] = renderedContents

        return renderedContents
    }

    public func stubbedContents(for contents: String) -> NSAttributedString {
        return producedContents[contents] ?? .random
    }

}
