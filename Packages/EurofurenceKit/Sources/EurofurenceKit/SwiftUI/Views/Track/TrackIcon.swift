import SwiftUI

/// An icon used to identify a `Track` within the model.
public struct TrackIcon: View {
    
    private let track: CanonicalTrack
    private let isSelected: Bool
    
    public init(_ track: Track, isSelected: Bool = false) {
        self.track = track.canonicalTrack
        self.isSelected = isSelected
    }
    
    public init(_ track: CanonicalTrack, isSelected: Bool = false) {
        self.track = track
        self.isSelected = isSelected
    }
    
    public var body: some View {
        let symbolName: String? = {
            if isSelected {
                return Self.tracksToSelectedSFSymbolNames[track]
            } else {
                return Self.tracksToUnselectedSFSymbolNames[track]
            }
        }()
        
        let defaultSymbolName = "calendar"
        SwiftUI.Image(systemName: symbolName ?? defaultSymbolName)
    }
    
    private static let tracksToUnselectedSFSymbolNames: [CanonicalTrack: String] = [
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
        .mainStage: "music.mic.circle",
        .supersponsor: "star.circle",
        .writing: "pencil.and.outline",
        .animation: "film",
        .dance: "music.note.house",
        .fursuitGroupPhoto: "camera"
    ]
    
    private static let tracksToSelectedSFSymbolNames: [CanonicalTrack: String] = [
        .artShow: "paintbrush.fill",
        .charity: "person.3.sequence.fill",
        .creatingArt: "paintpalette.fill",
        .dealersDen: "shippingbox.fill",
        .fursuit: "pawprint.fill",
        .gamesAndSocial: "gamecontroller.fill",
        .guestOfHonour: "person.fill",
        .lobbyAndOutdoor: "building.2.fill",
        .miscellaneous: "ellipsis.rectangle.fill",
        .music: "music.note",
        .performance: "theatermasks.fill",
        .mainStage: "music.mic.circle.fill",
        .supersponsor: "star.circle.fill",
        .writing: "pencil.and.outline",
        .animation: "film.fill",
        .dance: "music.note.house.fill",
        .fursuitGroupPhoto: "camera.fill"
    ]
    
    @ViewBuilder private var icon: some View {
        let symbolName: String? = {
            if isSelected {
                return Self.tracksToSelectedSFSymbolNames[track]
            } else {
                return Self.tracksToUnselectedSFSymbolNames[track]
            }
        }()
        
        let defaultSymbolName = "calendar"
        SwiftUI.Image(systemName: symbolName ?? defaultSymbolName)
    }
    
}

struct TrackIcon_LibraryItemProvider: LibraryContentProvider {
    
    @LibraryContentBuilder
    var views: [LibraryItem] {
        LibraryItem(
            TrackIcon(.artShow, isSelected: false),
            visible: true,
            title: "Track Icon",
            category: .control
        )
    }
    
}

struct TrackIcon_Previews: PreviewProvider {
    
    static var previews: some View {
        ForEach(CanonicalTrack.allCases) { track in
            Group {
                TrackIcon(track, isSelected: false)
                TrackIcon(track, isSelected: true)
            }
            .previewLayout(.sizeThatFits)
            .previewDisplayName(track.localizedDescription ?? "Unknown")
        }
    }
    
}
