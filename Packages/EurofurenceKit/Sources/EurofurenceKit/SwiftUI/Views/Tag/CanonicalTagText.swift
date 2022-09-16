import SwiftUI

/// A descriptive summary for well-known tags.
public struct CanonicalTagText: View {
    
    private let tag: CanonicalTag
    
    public init(_ tag: CanonicalTag) {
        self.tag = tag
    }
    
    public var body: some View {
        Text(verbatim: tag.localizedDescription)
    }
    
}

struct CanonicalTagText_Previews: PreviewProvider {
    
    static var previews: some View {
        ForEach(CanonicalTag.allCases) { tag in
            CanonicalTagText(tag)
                .previewLayout(.sizeThatFits)
                .previewDisplayName(tag.description)
        }
    }
    
}
