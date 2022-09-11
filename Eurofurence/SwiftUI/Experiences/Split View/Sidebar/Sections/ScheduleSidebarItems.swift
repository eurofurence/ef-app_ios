import EurofurenceKit
import SwiftUI

struct ScheduleSidebarItems: View {
    
    @State private var selectedDay: Day?
    @State private var selectedTrack: Track?
    
    var body: some View {
        Section {
            NavigationLink {
                ScheduleCollectionView()
            } label: {
                AllEventsLabel()
            }
            
            NavigationLink {
                Text("Favourite Events")
            } label: {
                FavouriteEventsLabel()
            }
            
            Divider()
            
            EventConferenceDaysView(selectedDay: $selectedDay)
            
            Divider()
            
            EventConferenceTracksView(selectedTrack: $selectedTrack)
        } header: {
            Text("Schedule")
        }
    }
    
}

struct ScheduleSidebarItems_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            NavigationView {
                List {
                    ScheduleSidebarItems()
                }
                .listStyle(.sidebar)
            }
            .navigationViewStyle(.stack)
            .previewLayout(.sizeThatFits)
        }
    }
    
}
