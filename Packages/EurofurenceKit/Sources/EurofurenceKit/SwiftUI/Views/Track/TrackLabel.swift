import SwiftUI

/// A descriptive label for well-known tracks.
public struct TrackLabel: View {
    
    private let track: CanonicalTrack
    private let unknownTrackText: String
    private let isSelected: Bool
    
    public init(_ track: Track, isSelected: Bool = false) {
        self.init(track: track.canonicalTrack, unknownTrackText: track.name, isSelected: isSelected)
    }
    
    public init(track: CanonicalTrack, unknownTrackText: String, isSelected: Bool) {
        self.track = track
        self.unknownTrackText = unknownTrackText
        self.isSelected = isSelected
    }
    
    public var body: some View {
        Label {
            TrackText(track, unknownTrackText: unknownTrackText)
        } icon: {
            TrackIcon(track, isSelected: isSelected)
        }
    }
    
}

struct CanonicalTrackLabel_LibraryContentProvider: LibraryContentProvider {
    
    @LibraryContentBuilder
    var views: [LibraryItem] {
        LibraryItem(
            TrackLabel(track: .mainStage, unknownTrackText: "", isSelected: false),
            visible: true,
            title: "Canonical Track Label",
            category: .control
        )
    }
    
}

struct CanonicalTrackLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        ForEach(CanonicalTrack.allCases) { track in
            Group {
                TrackLabel(track: track, unknownTrackText: "Placeholder", isSelected: false)
                TrackLabel(track: track, unknownTrackText: "Placeholder", isSelected: true)
            }
            .previewLayout(.sizeThatFits)
            .previewDisplayName(track.localizedDescription ?? "Unknown")
        }
    }
    
}
