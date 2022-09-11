import EurofurenceKit
import SwiftUI

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

struct ScheduleCollectionView_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            NavigationView {
                ScheduleCollectionView()
                    .navigationTitle("Preview")
            }
        }
    }
    
}
