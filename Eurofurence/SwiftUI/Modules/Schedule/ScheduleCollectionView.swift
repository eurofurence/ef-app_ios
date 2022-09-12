import EurofurenceKit
import SwiftUI

struct ScheduleCollectionView: View {
    
    @ObservedObject var schedule: ScheduleController
    
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
                    Text(group.id, format: .dateTime)
                }
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
                    track: model.track(for: .artShow)
                )

                let scheduleController = model.makeScheduleController(scheduleConfiguration: dayAndTrackConfiguration)
                ScheduleCollectionView(schedule: scheduleController)
                    .navigationTitle("Preview")
            }
        }
        .previewDisplayName("Track Specific Schedule")
    }
    
}
