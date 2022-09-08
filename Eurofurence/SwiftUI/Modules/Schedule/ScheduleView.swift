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
                    ScheduleCollectionView()
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
        .listStyle(.insetGrouped)
        .navigationTitle("Schedule")
        .onChange(of: searchQuery) { newValue in
            searchResults.nsPredicate = NSPredicate(format: "title CONTAINS[cd] %@", newValue)
        }
        .searchable(text: $searchQuery.animation(.spring()))
    }
    
}

struct ScheduleCollectionView: View {
    
    enum Filter {
        case day(Day)
        case track(Track)
    }
    
    @SectionedFetchRequest(
        entity: Event.entity(),
        sectionIdentifier: \Event.startDate,
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Event.startDate, ascending: true),
            NSSortDescriptor(keyPath: \Event.title, ascending: true)
        ]
    )
    private var eventGroups: SectionedFetchResults<Date, Event>
    
    var filter: Filter?
    
    var body: some View {
        List {
            ForEach(eventGroups) { group in
                Section {
                    ForEach(group) { (event) in
                        NavigationLink(event.title) {
                            Text(event.title)
                        }
                    }
                } header: {
                    Text(group.id, format: .dateTime)
                }
            }
        }
        .onAppear {
            if let filter = filter {
                switch filter {
                case .day(let day):
                    eventGroups.nsPredicate = Event.predicate(forEventsOccurringOn: day)
                case .track(let track):
                    eventGroups.nsPredicate = Event.predicate(forEventsInTrack: track)
                }
            }
        }
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
