import SwiftUI

/// A distinct icon to visualise an associated tag of an event.
public struct CanonicalTagIcon: View {
    
    private let tag: CanonicalTag
    
    public init(_ tag: CanonicalTag) {
        self.tag = tag
    }
    
    public var body: some View {
        if let symbolName = Self.tagToSFSymbolNames[tag] {
            SwiftUI.Image(systemName: symbolName)
        }
    }
    
    private static let tagToSFSymbolNames: [CanonicalTag: String] = [
        .sponsorOnly: "star.circle",
        .superSponsorOnly: "star.circle.fill",
        .artShow: "photo.artframe",
        .kage: "ant.fill",
        .dealersDen: "cart.fill",
        .mainStage: "asterisk.circle.fill",
        .photoshoot: "camera.fill",
        .faceMaskRequired: "facemask.fill"
    ]
    
}

struct CanonicalTagIcon_Previews: PreviewProvider {
    
    static var previews: some View {
        ForEach(CanonicalTag.allCases) { tag in
            CanonicalTagIcon(tag)
                .previewDisplayName(tag.description)
                .previewLayout(.sizeThatFits)
        }
    }
    
}
