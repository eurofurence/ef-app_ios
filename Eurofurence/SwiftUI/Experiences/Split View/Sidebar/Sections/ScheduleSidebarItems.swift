import EurofurenceKit
import SwiftUI

private extension Sidebar.Item {
    
    static let allEvents = Sidebar.Item("AllEvents")
    static let favouriteEvents = Sidebar.Item("FavouriteEvents")
    static func day(name: String) -> Sidebar.Item { Sidebar.Item(name) }
    static func track(track: String) -> Sidebar.Item { Sidebar.Item(track) }
    
}

struct ScheduleSidebarItems: View {
    
    @Binding var selectedItem: Sidebar.Item?
    
    @State private var selectedDay: Day?
    @State private var selectedTrack: Track?
    
    var body: some View {
        Section {
            NavigationLink(tag: Sidebar.Item.allEvents, selection: $selectedItem) {
                Text("All Events")
            } label: {
                Label {
                    Text("All Events")
                } icon: {
                    Image(systemName: "calendar")
                }
            }
            
            NavigationLink(tag: Sidebar.Item.favouriteEvents, selection: $selectedItem) {
                Text("Favourite Events")
            } label: {
                Label {
                    Text("Favourite Events")
                } icon: {
                    Image(systemName: selectedItem == .favouriteEvents ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
            
            Divider()
            
            EventConferenceDaysView(selectedDay: $selectedDay)
            
            Divider()
            
            EventConferenceTracksView(selectedTrack: $selectedTrack)
        } header: {
            Text("Schedule")
        }
        .onChange(of: selectedDay) { newValue in
            if let newValue = newValue {
                selectedItem = Sidebar.Item.day(name: newValue.name)
            }
        }
        .onChange(of: selectedTrack) { newValue in
            if let newValue = newValue {
                selectedItem = Sidebar.Item.track(track: newValue.name)
            }
        }
    }
    
}

struct ScheduleSidebarItems_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            NavigationView {
                List {
                    ScheduleSidebarItems(selectedItem: .constant(nil))
                }
                .listStyle(.sidebar)
            }
            .navigationViewStyle(.stack)
            .previewLayout(.sizeThatFits)
        }
    }
    
}
