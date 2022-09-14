/// Describes the feature of a well-known tag within the model.
public enum CanonicalTag {
    
    /// The associated event is only for Eurofurence Sponsors.
    case sponsorOnly
    
    /// The associated event is only for Eurofurence Super Sponsors.
    case superSponsorOnly
    
    /// The associated event is part of the Art Show.
    case artShow
    
    /// Bug spray banned 🪳🍷.
    case kage
    
    /// The associated event is part of the Dealers Den.
    case dealersDen
    
    /// The associated event takes place on the Main Stage.
    case mainStage
    
    /// The associated event is part of the photoshoot.
    case photoshoot
    
    /// Attendance to the associated event requires a fask mask.
    case faceMaskRequired
    
    private static let wellKnownTagsByName: [String: CanonicalTag] = [
        "sponsors_only": .sponsorOnly,
        "supersponsors_only": .superSponsorOnly,
        "art_show": .artShow,
        "kage": .kage,
        "dealers_den": .dealersDen,
        "main_stage": .mainStage,
        "photoshoot": .photoshoot,
        "mask_required": .faceMaskRequired
    ]
    
    static func wellKnownTag(named name: String) -> CanonicalTag? {
        wellKnownTagsByName[name]
    }
    
}
