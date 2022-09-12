import EurofurenceKit
import SwiftUI

struct EventConferenceDaysView: View {
    
    @EnvironmentObject private var model: EurofurenceModel
    
    @FetchRequest(fetchRequest: Day.temporallyOrderedFetchRequest())
    private var days: FetchedResults<Day>
    
    @Binding var selectedDay: Day?
    
    var body: some View {
        ForEach(days) { day in
            NavigationLink(tag: day, selection: $selectedDay) {
                let scheduleConfiguration = EurofurenceModel.ScheduleConfiguration(day: day)
                let schedule = model.makeScheduleController(scheduleConfiguration: scheduleConfiguration)
                ScheduleCollectionView(schedule: schedule)
                    .navigationTitle(day.name)
            } label: {
                DayLabel(day: day, isSelected: selectedDay == day)
            }
        }
    }
    
}

struct EventConferenceDaysView_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            NavigationView {            
                List {
                    EventConferenceDaysView(selectedDay: .constant(nil))
                }
            }
        }
    }
    
}
