import EurofurenceKit
import SwiftUI

struct EventConferenceTracksView: View {
    
    @FetchRequest(fetchRequest: Track.alphabeticallySortedFetchRequest())
    private var tracks: FetchedResults<Track>
    
    @EnvironmentObject private var model: EurofurenceModel
    
    @Binding var selectedTrack: Track?
    
    var body: some View {
        ForEach(tracks) { track in
            NavigationLink(tag: track, selection: $selectedTrack) {
                let scheduleConfiguration = EurofurenceModel.ScheduleConfiguration(track: track)
                let schedule = model.makeScheduleController(scheduleConfiguration: scheduleConfiguration)
                ScheduleCollectionView(schedule: schedule)
                    .navigationTitle(track.name)
            } label: {
                CanonicalTrackLabel(
                    track: track.canonicalTrack,
                    unknownTrackText: Text(verbatim: track.name),
                    isSelected: selectedTrack == track
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
