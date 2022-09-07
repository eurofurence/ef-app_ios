import EurofurenceKit
import SwiftUI

private extension Sidebar.Item {
    
    static let allEvents = Sidebar.Item("AllEvents")
    static let favouriteEvents = Sidebar.Item("FavouriteEvents")
    static func day(name: String) -> Sidebar.Item { Sidebar.Item(name) }
    static func track(track: String) -> Sidebar.Item { Sidebar.Item(track) }
    
}

struct ScheduleSidebarItems: View {
    
    var selectedItem: Binding<Sidebar.Item?>
    
    @FetchRequest(
        entity: Day.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Day.date, ascending: true)
        ]
    )
    private var days: FetchedResults<Day>
    
    @FetchRequest(
        entity: Track.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Track.name, ascending: true)
        ]
    )
    private var tracks: FetchedResults<Track>
    
    var body: some View {
        Section {
            NavigationLink(tag: Sidebar.Item.allEvents, selection: selectedItem) {
                Text("All Events")
            } label: {
                Label {
                    Text("All Events")
                } icon: {
                    Image(systemName: "calendar")
                }
            }
            
            NavigationLink(tag: Sidebar.Item.favouriteEvents, selection: selectedItem) {
                Text("Favourite Events")
            } label: {
                Label {
                    Text("Favourite Events")
                } icon: {
                    Image(systemName: selectedItem.wrappedValue == .favouriteEvents ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }
            
            Divider()
            
            ForEach(days) { day in
                NavigationLink(tag: Sidebar.Item.day(name: day.name), selection: selectedItem) {
                    Text(verbatim: day.name)
                } label: {
                    Label {
                        Text(verbatim: day.name)
                    } icon: {
                        let calendarDay = Calendar.current.component(.day, from: day.date)
                        let systemName = "\(calendarDay).square"
                        Image(systemName: systemName)
                    }
                }
            }
            
            Divider()
            
            ForEach(tracks) { track in
                NavigationLink(tag: Sidebar.Item.track(track: track.name), selection: selectedItem) {
                    Text(verbatim: track.name)
                } label: {
                    CanonicalTrackLabel(
                        track: track.canonicalTrack,
                        unknownTrackText: Text(verbatim: track.name)
                    )
                }
            }
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
                    ScheduleSidebarItems(selectedItem: .constant(nil))
                }
                .listStyle(.sidebar)
            }
            .navigationViewStyle(.stack)
            .previewLayout(.sizeThatFits)
        }
    }
    
}
