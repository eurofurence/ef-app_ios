import EurofurenceKit
import SwiftUI

struct ScheduleEventsList: View {
    
    @ObservedObject var schedule: Schedule
    @State private var selectedEvent: Event?
    
    var body: some View {
        List {
            ForEach(schedule.eventGroups) { group in
                Section {
                    events(for: group)
                } header: {
                    heading(for: group)
                }
            }
        }
        .listStyle(.plain)
        .overlay(placeholderView)
    }
    
    @ViewBuilder private var placeholderView: some View {
        if schedule.eventGroups.isEmpty {
            PlaceholderView()
        }
    }
    
    @ViewBuilder private func heading(for group: Schedule.EventGroup) -> some View {
        switch group.id {
        case .startDate(let date):
            FormattedShortTime(date)
            
        case .day(let day):
            Text(verbatim: day.name)
        }
    }
    
    @ViewBuilder private func events(for group: Schedule.EventGroup) -> some View {
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
    }
    
}

struct ScheduleEventsList_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { model in
            NavigationView {
                ScheduleEventsList(schedule: model.makeSchedule())
            }
            .previewDisplayName("All Events")
        }
        
        EurofurenceModel.preview { model in
            NavigationView {
                ScheduleEventsList(schedule: makeScheduleWithNoEvents(model: model))
            }
            .previewDisplayName("No Events")
        }
    }
    
    private static func makeScheduleWithNoEvents(model: EurofurenceModel) -> Schedule {
        let schedule = model.makeSchedule()
        schedule.query = "This event doesn't exist"
        
        return schedule
    }
    
}
