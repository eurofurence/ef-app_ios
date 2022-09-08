import EurofurenceKit
import SwiftUI

struct EventConferenceTracksView: View {
    
    @FetchRequest(
        entity: Track.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Track.name, ascending: true)
        ]
    )
    private var tracks: FetchedResults<Track>
    
    @Binding var selectedTrack: Track?
    
    var body: some View {
        ForEach(tracks) { track in
            NavigationLink(tag: track, selection: $selectedTrack) {
                ScheduleCollectionView(predicate: Event.predicate(forEventsInTrack: track))
                    .navigationTitle(track.name)
            } label: {
                CanonicalTrackLabel(
                    track: track.canonicalTrack,
                    unknownTrackText: Text(verbatim: track.name)
                )
            }
        }
    }
    
}

struct EventConferenceTracksView_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            NavigationView {
                List {
                    EventConferenceTracksView(selectedTrack: .constant(nil))
                }
            }
        }
    }
    
}
