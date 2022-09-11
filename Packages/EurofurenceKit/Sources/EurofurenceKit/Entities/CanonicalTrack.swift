/// Describes a well-defined event track within the model.
public enum CanonicalTrack: CaseIterable, Equatable, Hashable, Identifiable {
    
    public var id: some Hashable {
        self
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
