import SwiftUI

/// A descriptive label for well-known dealer categories.
public struct CanonicalDealerCategoryLabel: View {
    
    private let category: CanonicalDealerCategory
    
    public init(category: CanonicalDealerCategory) {
        self.category = category
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
            Text("Unknown", bundle: .module, comment: "Category title for unknown categories within the model")
        
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
            CanonicalDealerCategoryLabel(category: .miscellaneous),
            visible: true,
            title: "Canonical Dealer Category Label",
            category: .control
        )
    }
    
}

struct CanonicalDealerCategoryLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        ForEach(CanonicalDealerCategory.allCases) { category in
            CanonicalDealerCategoryLabel(category: category)
        }
    }
    
}
