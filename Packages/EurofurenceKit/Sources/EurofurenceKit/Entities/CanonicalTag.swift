import Foundation

/// Describes the feature of a well-known tag within the model.
public enum CanonicalTag: CaseIterable, CustomStringConvertible, Hashable, Identifiable {
    
    public var id: some Hashable {
        hashValue
    }
    
    public var description: String {
        switch self {
        case .sponsorOnly:
            return NSLocalizedString(
                "Sponsor Only",
                bundle: .module,
                comment: "Description used to denote an event where only sponsors may attend"
            )
            
        case .superSponsorOnly:
            return NSLocalizedString(
                "Super Sponsor Only",
                bundle: .module,
                comment: "Description used to denote an event where only super sponsors may attend"
            )
            
        case .artShow:
            return NSLocalizedString(
                "Art Show",
                bundle: .module,
                comment: "Description used to denote an event that is part of the art show"
            )
            
        case .kage:
            return NSLocalizedString(
                "Kage",
                bundle: .module,
                comment: "Description used to denote an event Kage is running or a featured panelist"
            )
            
        case .dealersDen:
            return NSLocalizedString(
                "Dealers Den",
                bundle: .module,
                comment: "Description used to denote an event that is part of the dealers den"
            )
            
        case .mainStage:
            return NSLocalizedString(
                "Main Stage",
                bundle: .module,
                comment: "Description used to denote an event that takes place on the main stage"
            )
            
        case .photoshoot:
            return NSLocalizedString(
                "Photoshoot",
                bundle: .module,
                comment: "Description used to denote an event that is part of the photoshoot track"
            )
            
        case .faceMaskRequired:
            return NSLocalizedString(
                "Fake Mask Required",
                bundle: .module,
                comment: "Description used to denote an event where a face mask is required to enter"
            )
            
        }
    }
    
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
