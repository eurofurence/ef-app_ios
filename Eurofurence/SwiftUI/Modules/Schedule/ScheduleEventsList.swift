import EurofurenceKit
import SwiftUI

struct ScheduleEventsList: View {
    
    @ObservedObject var schedule: Schedule
    @State private var selectedEvent: Event?
    
    var body: some View {
        List {
            ForEach(schedule.eventGroups) { group in
                Section {
                    ForEach(group.elements) { (event) in
                        NavigationLink(tag: event, selection: $selectedEvent) {
                            Lazy {
                                Text(event.title)
                            }
                        } label: {
                            EventListRow(
                                event: event,
                                configuration: EventListRow.Configuration(
                                    displayTrackName: schedule.selectedTrack == nil,
                                    displayRoomName: schedule.selectedRoom == nil
                                )
                            )
                        }
                    }
                } header: {
                    switch group.id {
                    case .startDate(let date):
                        FormattedShortTime(date)
                        
                    case .day(let day):
                        Text(verbatim: day.name)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
    
}

struct ScheduleEventsList_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { model in
            NavigationView {
                ScheduleEventsList(schedule: model.makeSchedule())
            }
        }
    }
    
}
