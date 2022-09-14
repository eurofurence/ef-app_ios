import EurofurenceKit
import SwiftUI

struct ScheduleCollectionView: View {
    
    @EnvironmentObject var model: EurofurenceModel
    @ObservedObject var schedule: Schedule
    @State private var isPresentingFilter = false
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
                            EventListRow(event: event)
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
        .toolbar {
            ToolbarItem(placement: .status) {
                statusView
            }
            
            ToolbarItem(placement: .bottomBar) {
                ScheduleFilterButton(isPresentingFilter: $isPresentingFilter, schedule: schedule)
            }
        }
    }
    
    @ViewBuilder
    private var statusView: some View {
        VStack {
            Text(
                "\(schedule.matchingEventsCount) matching events",
                comment: "Format for presenting the number of matching events in a schedule"
            )
            .font(.caption)
            
            if let localizedFilterDescription = schedule.localizedFilterDescription {
                Text(verbatim: localizedFilterDescription)
                    .font(.caption2)
            }
        }
    }
    
}

private struct ScheduleFilterButton: View {
    
    @Binding var isPresentingFilter: Bool
    var schedule: Schedule
    
    var body: some View {
        Button {
            isPresentingFilter.toggle()
        } label: {
            Label {
                Text("Filter")
            } icon: {
                if isPresentingFilter {
                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
                } else {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .popover(isPresented: $isPresentingFilter) {
            NavigationView {
                ScheduleFilterView(schedule: schedule)
            }
            .sensiblePopoverFrame()
        }
        .enablingMediumPresentationDetent()
    }
    
}

private struct ScheduleFilterView: View {
    
    @ObservedObject var schedule: Schedule
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            if schedule.availableDays.isEmpty == false {
                Section {
                    ScheduleDayPicker(schedule: schedule)
                } header: {
                    Text("Day")
                }
            }
            
            if schedule.availableTracks.isEmpty == false {
                Section {
                    ScheduleTrackPicker(schedule: schedule)
                } header: {
                    Text("Track")
                }
            }
            
            if schedule.availableRooms.isEmpty == false {
                Section {
                    ScheduleRoomPicker(schedule: schedule)
                } header: {
                    Text("Room")
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Filters")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
    }
    
}

private struct ScheduleDayPicker: View {
    
    @ObservedObject var schedule: Schedule
    
    var body: some View {
        SelectableRow(tag: nil, selection: $schedule.selectedDay.animation()) {
            Label {
                Text("Entire Convention")
            } icon: {
                if schedule.selectedTrack == nil {
                    Image(systemName: "calendar.circle.fill")
                } else {
                    Image(systemName: "calendar.circle")
                }
            }
        }
        
        ForEach(schedule.availableDays) { day in
            SelectableRow(tag: day, selection: $schedule.selectedDay.animation()) {
                DayLabel(day: day, isSelected: schedule.selectedDay == day)
            }
        }
    }
    
}

private struct ScheduleTrackPicker: View {
    
    @ObservedObject var schedule: Schedule
    
    var body: some View {
        SelectableRow(tag: nil, selection: $schedule.selectedTrack.animation()) {
            Label {
                Text("All Tracks")
            } icon: {
                if schedule.selectedTrack == nil {
                    Image(systemName: "square.stack.fill")
                } else {
                    Image(systemName: "square.stack")
                }
            }
        }
        
        ForEach(schedule.availableTracks) { track in
            SelectableRow(tag: track, selection: $schedule.selectedTrack.animation()) {
                TrackLabel(track, isSelected: schedule.selectedTrack == track)
            }
        }
    }
    
}

private struct ScheduleRoomPicker: View {
    
    @ObservedObject var schedule: Schedule
    
    var body: some View {
        SelectableRow(tag: nil, selection: $schedule.selectedRoom.animation()) {
            Text("Everywhere")
        }
        
        ForEach(schedule.availableRooms) { room in
            SelectableRow(tag: room, selection: $schedule.selectedRoom.animation()) {
                Text(room.shortName)
            }
        }
    }
    
}

struct ScheduleCollectionView_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { model in
            NavigationView {
                ScheduleCollectionView(schedule: model.makeSchedule())
                    .navigationTitle("Preview")
            }
            .previewDisplayName("Unconfigured Schedule")
            
            NavigationView {
                let dayConfiguration = EurofurenceModel.ScheduleConfiguration(day: model.day(for: .conDayTwo))
                ScheduleCollectionView(schedule: model.makeSchedule(configuration: dayConfiguration))
                    .navigationTitle("Preview")
            }
            .previewDisplayName("Day Specific Schedule")
            
            NavigationView {
                let trackConfiguration = EurofurenceModel.ScheduleConfiguration(track: model.track(for: .clubStage))
                ScheduleCollectionView(schedule: model.makeSchedule(configuration: trackConfiguration))
                    .navigationTitle("Preview")
            }
            .previewDisplayName("Track Specific Schedule")
            
            NavigationView {
                let dayAndTrackConfiguration = EurofurenceModel.ScheduleConfiguration(
                    day: model.day(for: .conDayTwo),
                    track: model.track(for: .clubStage)
                )
                
                let scheduleController = model.makeSchedule(configuration: dayAndTrackConfiguration)
                ScheduleCollectionView(schedule: scheduleController)
                    .navigationTitle("Preview")
            }
            .previewDisplayName("Day + Track Specific Schedule")
        }
    }
    
}
