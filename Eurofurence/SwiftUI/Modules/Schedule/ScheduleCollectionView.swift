import EurofurenceKit
import SwiftUI

struct ScheduleCollectionView: View {
    
    @EnvironmentObject var model: EurofurenceModel
    @ObservedObject var schedule: ScheduleController
    @State private var isPresentingFilter = false
    
    var body: some View {
        List {
            ForEach(schedule.eventGroups) { group in
                Section {
                    ForEach(group.elements) { (event) in
                        NavigationLink(event.title) {
                            Text(event.title)
                        }
                    }
                } header: {
                    switch group.id {
                    case .startDate(let date):
                        Text(date, format: Date.FormatStyle(date: .omitted, time: .shortened))
                        
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
    var schedule: ScheduleController
    
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
    
    @ObservedObject var schedule: ScheduleController
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
    
    @ObservedObject var schedule: ScheduleController
    
    var body: some View {
        ForEach(schedule.availableDays) { day in
            SelectableRow(tag: day, selection: $schedule.selectedDay.animation()) {
                DayLabel(day: day, isSelected: schedule.selectedDay == day)
            }
        }
    }
    
}

private struct ScheduleTrackPicker: View {
    
    @ObservedObject var schedule: ScheduleController
    
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
                CanonicalTrackLabel(
                    track: track.canonicalTrack,
                    unknownTrackText: Text(track.name),
                    isSelected: schedule.selectedTrack == track
                )
            }
        }
    }
    
}

private struct ScheduleRoomPicker: View {
    
    @ObservedObject var schedule: ScheduleController
    
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
                ScheduleCollectionView(schedule: model.makeScheduleController())
                    .navigationTitle("Preview")
            }
        }
        .previewDisplayName("Unconfigured Schedule")
        
        EurofurenceModel.preview { model in
            NavigationView {
                let dayConfiguration = EurofurenceModel.ScheduleConfiguration(day: model.day(for: .conDayTwo))
                ScheduleCollectionView(schedule: model.makeScheduleController(scheduleConfiguration: dayConfiguration))
                    .navigationTitle("Preview")
            }
        }
        .previewDisplayName("Day Specific Schedule")
        
        EurofurenceModel.preview { model in
            NavigationView {
                let trackConfiguration = EurofurenceModel.ScheduleConfiguration(track: model.track(for: .artShow))
                ScheduleCollectionView(schedule: model.makeScheduleController(scheduleConfiguration: trackConfiguration))
                    .navigationTitle("Preview")
            }
        }
        .previewDisplayName("Track Specific Schedule")
        
        EurofurenceModel.preview { model in
            NavigationView {
                let dayAndTrackConfiguration = EurofurenceModel.ScheduleConfiguration(
                    day: model.day(for: .conDayTwo),
                    track: model.track(for: .artistLounge)
                )
                
                let scheduleController = model.makeScheduleController(scheduleConfiguration: dayAndTrackConfiguration)
                ScheduleCollectionView(schedule: scheduleController)
                    .navigationTitle("Preview")
            }
        }
        .previewDisplayName("Day + Track Specific Schedule")
    }
    
}
