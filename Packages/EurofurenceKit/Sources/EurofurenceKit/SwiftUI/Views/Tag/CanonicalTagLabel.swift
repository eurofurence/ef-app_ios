import SwiftUI

/// A descriptive label for well-known tags.
public struct CanonicalTagLabel: View {
    
    private let tag: CanonicalTag
    
    public init(_ tag: CanonicalTag) {
        self.tag = tag
    }
    
    public var body: some View {
        Label {
            CanonicalTagText(tag)
        } icon: {
            CanonicalTagIcon(tag)
        }
    }
    
}

struct CanonicalTagLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        ForEach(CanonicalTag.allCases) { tag in
            CanonicalTagLabel(tag)
                .previewLayout(.sizeThatFits)
                .previewDisplayName(tag.description)
        }
    }
    
}
