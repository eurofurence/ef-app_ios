import SwiftUI

/// A descriptive label for well-known dealer categories.
public struct CanonicalDealerCategoryLabel: View {
    
    private let category: CanonicalDealerCategory
    private let unknownCategoryText: Text
    
    public init(category: CanonicalDealerCategory, unknownCategoryText: Text) {
        self.category = category
        self.unknownCategoryText = unknownCategoryText
    }
    
    public var body: some View {
        Label {
            text
        } icon: {
            icon
        }
    }
    
    @ViewBuilder private var text: some View {
        switch category {
        case .unknown:
            unknownCategoryText
        
        case .prints:
            Text("Prints", bundle: .module, comment: "Title for the Prints dealer category")
        
        case .fursuits:
            Text("Fursuits", bundle: .module, comment: "Title for the Fursuits dealer category")
        
        case .commissions:
            Text("Commissions", bundle: .module, comment: "Title for the Commissions dealer category")
        
        case .artwork:
            Text("Artwork", bundle: .module, comment: "Title for the Artwork dealer category")
        
        case .miscellaneous:
            Text("Miscellaneous", bundle: .module, comment: "Title for the Miscellaneous dealer category")
        }
    }
    
    private static let categoriesToSFSymbols: [CanonicalDealerCategory: String] = [
        .prints: "printer",
        .fursuits: "pawprint",
        .commissions: "photo.artframe",
        .artwork: "paintbrush",
        .miscellaneous: "ellipsis.rectangle"
    ]
    
    @ViewBuilder private var icon: some View {
        let symbolName = Self.categoriesToSFSymbols[category, default: "cart"]
        SwiftUI.Image(systemName: symbolName)
    }
    
}

struct CanonicalDealerCategoryLabel_LibraryContentProvider: LibraryContentProvider {
    
    @LibraryContentBuilder
    var views: [LibraryItem] {
        LibraryItem(
            CanonicalDealerCategoryLabel(category: .miscellaneous, unknownCategoryText: Text("")),
            visible: true,
            title: "Canonical Dealer Category Label",
            category: .control
        )
    }
    
}

struct CanonicalDealerCategoryLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        ForEach(CanonicalDealerCategory.allCases) { category in
            CanonicalDealerCategoryLabel(category: category, unknownCategoryText: Text("Placeholder"))
        }
    }
    
}
