import SwiftUI

/// A descriptive label for well-known tracks.
public struct CanonicalTrackLabel: View {
    
    private let track: CanonicalTrack
    private let unknownTrackText: Text
    
    public init(track: CanonicalTrack, unknownTrackText: Text) {
        self.track = track
        self.unknownTrackText = unknownTrackText
    }
    
    public var body: some View {
        Label {
            text
        } icon: {
            icon
        }
    }
    
    @ViewBuilder private var text: some View {
        switch track {
        case .unknown:
            unknownTrackText
        
        case .artShow:
            Text("Art Show", bundle: .module, comment: "Track title for the Art Show track")
        
        case .charity:
            Text("Charity", bundle: .module, comment: "Track title for the Charity track")
        
        case .creatingArt:
            Text("Creating Art", bundle: .module, comment: "Track title for the Creating Art track")
        
        case .dealersDen:
            Text("Dealers Den", bundle: .module, comment: "Track title for the Dealers Den track")
        
        case .fursuit:
            Text("Fursuit", bundle: .module, comment: "Track title for the Fursuit track")
        
        case .gamesAndSocial:
            Text("Games and Social", bundle: .module, comment: "Track title for the Games and Social track")
        
        case .guestOfHonour:
            Text("Guest of Honor", bundle: .module, comment: "Track title for the Guest of Honor track")
        
        case .lobbyAndOutdoor:
            Text("Lobby and Outdoor", bundle: .module, comment: "Track title for the Lobby and Outdoor track")
        
        case .miscellaneous:
            Text("Miscellaneous", bundle: .module, comment: "Track title for the Miscellaneous track")
        
        case .music:
            Text("Music", bundle: .module, comment: "Track title for the Music track")
        
        case .performance:
            Text("Performance", bundle: .module, comment: "Track title for the Performance track")
        
        case .mainStage:
            Text("Main Stage", bundle: .module, comment: "Track title for the Main Stage track")
        
        case .supersponsor:
            Text("Supersponsor", bundle: .module, comment: "Track title for the Supersponsor track")
        
        case .writing:
            Text("Writing", bundle: .module, comment: "Track title for the Writing track")
        
        case .animation:
            Text("Animation", bundle: .module, comment: "Track title for the Animation track")
        
        case .dance:
            Text("Dance", bundle: .module, comment: "Track title for the Dance track")
        
        case .fursuitGroupPhoto:
            Text("Fursuit Group Photo", bundle: .module, comment: "Track title for the Fursuit Group Photo track")
        }
    }
    
    private static let tracksToSFSymbolNames: [CanonicalTrack: String] = [
        .artShow: "paintbrush",
        .charity: "person.3.sequence",
        .creatingArt: "paintpalette",
        .dealersDen: "shippingbox",
        .fursuit: "pawprint",
        .gamesAndSocial: "gamecontroller",
        .guestOfHonour: "person",
        .lobbyAndOutdoor: "building.2",
        .miscellaneous: "ellipsis.rectangle",
        .music: "music.note",
        .performance: "theatermasks",
        .mainStage: "music.mic",
        .supersponsor: "star.circle",
        .writing: "pencil.and.outline",
        .animation: "film",
        .dance: "music.note.house",
        .fursuitGroupPhoto: "camera"
    ]
    
    @ViewBuilder private var icon: some View {
        let symbolName = Self.tracksToSFSymbolNames[track, default: "calendar"]
        SwiftUI.Image(systemName: symbolName)
    }
    
}

struct CanonicalTrackLabel_LibraryContentProvider: LibraryContentProvider {
    
    @LibraryContentBuilder
    var views: [LibraryItem] {
        LibraryItem(
            CanonicalTrackLabel(track: .mainStage, unknownTrackText: Text("")),
            visible: true,
            title: "Canonical Track Label",
            category: .control
        )
    }
    
}

struct CanonicalTrackLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        ForEach(CanonicalTrack.allCases) { track in
            CanonicalTrackLabel(track: track, unknownTrackText: Text("Placeholder"))
        }
    }
    
}
