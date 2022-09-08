import EurofurenceKit
import SwiftUI

struct EventConferenceDaysView: View {
    
    @FetchRequest(
        entity: Day.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Day.date, ascending: true)
        ]
    )
    private var days: FetchedResults<Day>
    
    @Binding var selectedDay: Day?
    
    var body: some View {
        ForEach(days) { day in
            NavigationLink(tag: day, selection: $selectedDay) {
                Text(verbatim: day.name)
            } label: {
                Label {
                    Text(verbatim: day.name)
                } icon: {
                    let calendarDay = Calendar.current.component(.day, from: day.date)
                    let systemName = "\(calendarDay).square"
                    Image(systemName: systemName)
                }
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
