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
                Lazy {                
                    let scheduleConfiguration = EurofurenceModel.ScheduleConfiguration(track: track)
                    let schedule = model.makeSchedule(configuration: scheduleConfiguration)
                    ScheduleCollectionView(schedule: schedule)
                        .navigationTitle(track.name)
                }
            } label: {
                TrackLabel(track, isSelected: selectedTrack == track)
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
