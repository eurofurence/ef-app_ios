import SwiftUI

/// A `View` capable of rendering textual markdown.
public struct MarkdownContent: View {
    
    private let markdown: String
    
    public init(_ markdown: String) {
        self.markdown = markdown
    }
    
    public var body: some View {
        let key = LocalizedStringKey(markdown)
        Text(key)
    }
    
}
