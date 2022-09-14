import EurofurenceKit
import SwiftUI

struct ScheduleView: View {
    
    @ObservedObject var schedule: Schedule
    
    @State private var selectedDay: Day?
    @State private var selectedTrack: Track?
    
    var body: some View {
        root
            .navigationTitle("Schedule")
            .searchable(text: $schedule.query.animation())
    }
    
    @ViewBuilder private var root: some View {
        if schedule.query.isEmpty {
            scheduleRoot
        } else {
            ScheduleEventsList(schedule: schedule)
        }
    }
    
    @ViewBuilder private var scheduleRoot: some View {
        List {
            if schedule.query.isEmpty {
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
                ScheduleCollectionView(schedule: schedule)
            }
        }
        .refreshesModel()
        .listStyle(.insetGrouped)
    }
    
}

struct ScheduleView_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { model in
            NavigationView {
                ScheduleView(schedule: model.makeSchedule())
            }
        }
    }
    
}
