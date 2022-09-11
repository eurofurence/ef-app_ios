/// Describes a well-defined Dealer category within the model.
public enum CanonicalDealerCategory: CaseIterable, Equatable, Hashable, Identifiable {
    
    public var id: some Hashable {
        self
    }
    
    /// The category has no local canonical meaning. This is a signal the remote has added a new category
    /// the current model cannot process.
    case unknown
    
    /// The dealer offers printed material.
    case prints
    
    /// The dealer offers fursuit wares, e.g. accessories, parts or commissions.
    case fursuits
    
    /// The dealer is taking commissions.
    case commissions
    
    /// The dealer offers artwork.
    case artwork
    
    /// The dealer offers miscellaneous, uncategorised wares.
    case miscellaneous
    
    init(categoryName: String) {
        let lowercasedCategoryName = categoryName.lowercased()
        switch lowercasedCategoryName {
        case "prints":
            self = .prints
            
        case "fursuits":
            self = .fursuits
            
        case "commissions":
            self = .commissions
            
        case "artwork":
            self = .artwork
            
        case "miscellaneous":
            self = .miscellaneous
            
        default:
            self = .unknown
        }
    }
    
}
