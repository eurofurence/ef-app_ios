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
    
    public struct SampleDay: Hashable, Identifiable {
        
        public var id: some Hashable {
            self
        }
        
        var calendarDay: Int
        var name: String
        
        static var all: [SampleDay] = {
            return [
                SampleDay(calendarDay: 23, name: "Early Arrival"),
                SampleDay(calendarDay: 24, name: "Official Con Start/Con Day 1"),
                SampleDay(calendarDay: 25, name: "Con Day 2"),
                SampleDay(calendarDay: 26, name: "Con Day 3"),
                SampleDay(calendarDay: 27, name: "Con Day 4"),
                SampleDay(calendarDay: 28, name: "Last Day/Con Day 5")
            ]
        }()
        
    }
    
    // Just for testing the design.
    private struct SampleTrack: Hashable, Identifiable {
        
        var id: some Hashable {
            self
        }
        
        var name: String
        var symbolName: String
        
        static var all: [SampleTrack] = {
            return [
                SampleTrack(name: "Art Show", symbolName: "paintbrush"),
                SampleTrack(name: "Charity", symbolName: "person.3.sequence"),
                SampleTrack(name: "Creating Art", symbolName: "paintpalette"),
                SampleTrack(name: "Dealer's Den", symbolName: "shippingbox"),
                SampleTrack(name: "Fursuit", symbolName: "pawprint"),
                SampleTrack(name: "Games | Social", symbolName: "gamecontroller"),
                SampleTrack(name: "Guest of Honor", symbolName: "person"),
                SampleTrack(name: "Lobby and Outdoor", symbolName: "building.2"),
                SampleTrack(name: "Misc.", symbolName: "ellipsis.rectangle"),
                SampleTrack(name: "Music", symbolName: "music.note"),
                SampleTrack(name: "Performance", symbolName: "theatermasks"),
                SampleTrack(name: "Stage", symbolName: "music.mic"),
                SampleTrack(name: "Supersponsor Event", symbolName: "star.circle"),
                SampleTrack(name: "Writing", symbolName: "pencil.and.outline"),
                SampleTrack(name: "Animation", symbolName: "film"),
                SampleTrack(name: "Dance", symbolName: "music.note.house"),
                SampleTrack(name: "Maker ∕ Theme-based Fursuit Group Photo", symbolName: "camera")
            ]
        }()
        
    }
    
    private let exampleDays: [SampleDay] = SampleDay.all
    private let exampleTracks: [SampleTrack] = SampleTrack.all
    
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
            
            ForEach(exampleDays) { day in
                NavigationLink(tag: Sidebar.Item.day(name: day.name), selection: selectedItem) {
                    Text(verbatim: day.name)
                } label: {
                    Label {
                        Text(verbatim: day.name)
                    } icon: {
                        let systemName = "\(day.calendarDay).square"
                        Image(systemName: systemName)
                    }
                }
            }
            
            Divider()
            
            ForEach(exampleTracks) { track in
                NavigationLink(tag: Sidebar.Item.track(track: track.name), selection: selectedItem) {
                    Text(verbatim: track.name)
                } label: {
                    Label {
                        Text(verbatim: track.name)
                    } icon: {
                        Image(systemName: track.symbolName)
                    }
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
