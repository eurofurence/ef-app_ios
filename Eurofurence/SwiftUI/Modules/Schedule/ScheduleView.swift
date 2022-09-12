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
                .headerProminence(.increased)
                
                Section {
                    EventConferenceTracksView(selectedTrack: $selectedTrack)
                } header: {
                    Text("Tracks")
                }
                .headerProminence(.increased)
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
        .refreshesModel()
        .listStyle(.insetGrouped)
        .navigationTitle("Schedule")
        .onChange(of: searchQuery) { newValue in
            searchResults.nsPredicate = Event.predicateForTextualSearch(query: newValue)
        }
        .searchable(text: $searchQuery)
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
