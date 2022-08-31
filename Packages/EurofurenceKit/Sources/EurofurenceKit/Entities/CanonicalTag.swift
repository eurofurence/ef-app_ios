/// Describes the feature of a well-known tag within the model.
public struct CanonicalTag: OptionSet {
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
}

// MARK: - Well Defined Tags

extension CanonicalTag {
    
    /// The associated event is only for Eurofurence Sponsors.
    public static let sponsorOnly = CanonicalTag(rawValue: 1 << 0)
    
    /// The associated event is only for Eurofurence Super Sponsors.
    public static let superSponsorOnly = CanonicalTag(rawValue: 1 << 1)
    
    /// The associated event is part of the Art Show.
    public static let artShow = CanonicalTag(rawValue: 1 << 2)
    
    /// Bug spray banned 🪳🍷.
    public static let kage = CanonicalTag(rawValue: 1 << 3)
    
    /// The associated event is part of the Dealers Den.
    public static let dealersDen = CanonicalTag(rawValue: 1 << 4)
    
    /// The associated event takes place on the Main Stage.
    public static let mainStage = CanonicalTag(rawValue: 1 << 5)
    
    /// The associated event is part of the photoshoot.
    public static let photoshoot = CanonicalTag(rawValue: 1 << 6)
    
    /// Attendance to the associated event requires a fask mask.
    public static let faceMaskRequired = CanonicalTag(rawValue: 1 << 7)
    
}
