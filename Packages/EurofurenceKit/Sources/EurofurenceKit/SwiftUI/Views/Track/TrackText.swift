import SwiftUI

/// A descriptive summary for well-known tracks.
public struct TrackText: View {
    
    private let track: CanonicalTrack
    private let unknownTrackText: String
    
    public init(_ track: Track) {
        self.init(track.canonicalTrack, unknownTrackText: track.name)
    }
    
    public init(_ track: CanonicalTrack, unknownTrackText: String) {
        self.track = track
        self.unknownTrackText = unknownTrackText
    }
    
    public var body: some View {
        Text(verbatim: track.localizedDescription ?? unknownTrackText)
    }
    
}

struct TrackText_LibraryContentProvider: LibraryContentProvider {
    
    @LibraryContentBuilder
    var views: [LibraryItem] {
        LibraryItem(
            TrackText(.mainStage, unknownTrackText: ""),
            visible: true,
            title: "Track Text",
            category: .control
        )
    }
    
}

struct TrackText_Previews: PreviewProvider {
    
    static var previews: some View {
        ForEach(CanonicalTrack.allCases) { track in
            Group {
                TrackText(track, unknownTrackText: "Placeholder")
                TrackText(track, unknownTrackText: "Placeholder")
            }
            .previewLayout(.sizeThatFits)
            .previewDisplayName(track.localizedDescription ?? "Unknown")
        }
    }
    
}
