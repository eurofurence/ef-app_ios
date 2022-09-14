import Foundation

/// Describes a well-defined event track within the model.
public enum CanonicalTrack: CaseIterable, Equatable, Hashable, Identifiable {
    
    public var id: some Hashable {
        self
    }
    
    /// A localized description of this track, or `nil` if the track is the `unknown` track.
    public var localizedDescription: String? {
        switch self {
        case .unknown:
            return nil
        
        case .artShow:
            return NSLocalizedString(
                "Art Show",
                bundle: .module,
                comment: "Track title for the Art Show track"
            )
        
        case .charity:
            return NSLocalizedString(
                "Charity",
                bundle: .module,
                comment: "Track title for the Charity track"
            )
        
        case .creatingArt:
            return NSLocalizedString(
                "Creating Art",
                bundle: .module,
                comment: "Track title for the Creating Art track"
            )
        
        case .dealersDen:
            return NSLocalizedString(
                "Dealers Den",
                bundle: .module,
                comment: "Track title for the Dealers Den track"
            )
        
        case .fursuit:
            return NSLocalizedString(
                "Fursuit",
                bundle: .module,
                comment: "Track title for the Fursuit track"
            )
        
        case .gamesAndSocial:
            return NSLocalizedString(
                "Games and Social",
                bundle: .module,
                comment: "Track title for the Games and Social track"
            )
        
        case .guestOfHonour:
            return NSLocalizedString(
                "Guest of Honor",
                bundle: .module,
                comment: "Track title for the Guest of Honor track"
            )
        
        case .lobbyAndOutdoor:
            return NSLocalizedString(
                "Lobby and Outdoor",
                bundle: .module,
                comment: "Track title for the Lobby and Outdoor track"
            )
        
        case .miscellaneous:
            return NSLocalizedString(
                "Miscellaneous",
                bundle: .module,
                comment: "Track title for the Miscellaneous track"
            )
        
        case .music:
            return NSLocalizedString(
                "Music",
                bundle: .module,
                comment: "Track title for the Music track"
            )
        
        case .performance:
            return NSLocalizedString(
                "Performance",
                bundle: .module,
                comment: "Track title for the Performance track"
            )
        
        case .mainStage:
            return NSLocalizedString(
                "Main Stage",
                bundle: .module,
                comment: "Track title for the Main Stage track"
            )
        
        case .supersponsor:
            return NSLocalizedString(
                "Supersponsor",
                bundle: .module,
                comment: "Track title for the Supersponsor track"
            )
        
        case .writing:
            return NSLocalizedString(
                "Writing",
                bundle: .module,
                comment: "Track title for the Writing track"
            )
        
        case .animation:
            return NSLocalizedString(
                "Animation",
                bundle: .module,
                comment: "Track title for the Animation track"
            )
        
        case .dance:
            return NSLocalizedString(
                "Dance",
                bundle: .module,
                comment: "Track title for the Dance track"
            )
        
        case .fursuitGroupPhoto:
            return NSLocalizedString(
                "Fursuit Group Photo",
                bundle: .module,
                comment: "Track title for the Fursuit Group Photo track"
            )
        }
    }
    
    /// The track has no local canonical meaning. This is a signal the remote has added a new track
    /// the current model cannot process.
    case unknown
    
    /// The track is for events that are part of the Art Show.
    case artShow
    
    /// The track is for events that are hosted by, or are for, the con charity.
    case charity
    
    /// The track is for events pertaining to flexing the attendees creative muscles.
    case creatingArt
    
    /// The track is for events hosted within the dealers den
    case dealersDen
    
    /// The track is for events designed for fursuiters
    case fursuit
    
    /// The track is for social events, such as games
    case gamesAndSocial
    
    /// The track is for events hosted by, or in the presence of, the guest of honor
    case guestOfHonour
    
    /// The track is for events in or around the lobby, or the outdoor area of the venue
    case lobbyAndOutdoor
    
    /// The track is for miscellaneous, uncategorised, events
    case miscellaneous
    
    /// The track is for events related to musical performance
    case music
    
    /// The track is for performance events
    case performance
    
    /// The track is for events taking place on the main stage
    case mainStage
    
    /// The track is for events only available to convention super-sponsors
    case supersponsor
    
    /// The track is for events pertaining to literature and writing
    case writing
    
    /// The track is for events about animation
    case animation
    
    /// The track is for dance events
    case dance
    
    /// The track is for events where fursuiters can be captured in group photos, e.g. by maker or theme
    case fursuitGroupPhoto
    
    private static let canonicalTracksByLowercaseName: [String: CanonicalTrack] = [
        "art show": .artShow,
        "charity": .charity,
        "creating art": .creatingArt,
        "dealers' den": .dealersDen,
        "fursuit": .fursuit,
        "games | social": .gamesAndSocial,
        "guest of honor": .guestOfHonour,
        "lobby and outdoor": .lobbyAndOutdoor,
        "misc.": .miscellaneous,
        "music": .music,
        "performance": .performance,
        "stage": .mainStage,
        "supersponsor event": .supersponsor,
        "writing": .writing,
        "animation": .animation,
        "dance": .dance,
        "maker ∕ theme-based fursuit group photo": .fursuitGroupPhoto
    ]
    
    init(trackName: String) {
        let lowercasedName = trackName.lowercased()
        self = Self.canonicalTracksByLowercaseName[lowercasedName, default: .unknown]
    }
    
}
