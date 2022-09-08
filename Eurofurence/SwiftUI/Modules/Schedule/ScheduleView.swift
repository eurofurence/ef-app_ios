import EurofurenceKit
import SwiftUI

struct ScheduleView: View {
    
    @SectionedFetchRequest(
        entity: Event.entity(),
        sectionIdentifier: \EurofurenceKit.Event.day.name,
        sortDescriptors: [
            NSSortDescriptor(key: "day.date", ascending: true)
        ],
        animation: .spring()
    )
    private var searchResults: SectionedFetchResults<String, Event>
    
    @State private var searchQuery: String = ""
    @State private var selectedDay: Day?
    @State private var selectedTrack: Track?
    
    var body: some View {
        List {
            if searchQuery.isEmpty {
                NavigationLink {
                    Text("All Events")
                } label: {
                    Label {
                        Text("All Events")
                    } icon: {
                        Image(systemName: "calendar")
                    }
                }
                
                NavigationLink {
                    Text("Favourite Events")
                } label: {
                    Label {
                        Text("Favourite Events")
                    } icon: {
                        Image(systemName: "heart")
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    EventConferenceDaysView(selectedDay: $selectedDay)
                } header: {
                    Text("Days")
                }
                
                Section {
                    EventConferenceTracksView(selectedTrack: $selectedTrack)
                } header: {
                    Text("Tracks")
                }
            } else {
                ForEach(searchResults) { group in
                    Section {
                        ForEach(group) { event in
                            NavigationLink {
                                Text(event.title)
                            } label: {
                                Text(event.title)
                            }
                        }
                    } header: {
                        Text(group.id)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Schedule")
        .onChange(of: searchQuery) { newValue in
            searchResults.nsPredicate = NSPredicate(format: "title CONTAINS[cd] %@", newValue)
        }
        .searchable(text: $searchQuery.animation(.spring()))
    }
    
}

struct ScheduleView_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            NavigationView {
                ScheduleView()
            }
        }
    }
    
}
