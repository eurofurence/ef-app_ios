import SwiftUI

/// A descriptive label for a `Day` within the model.
public struct DayLabel: View {
    
    @ObservedObject private var day: Day
    private let isSelected: Bool
    
    public init(day: Day, isSelected: Bool) {
        self.day = day
        self.isSelected = isSelected
    }
    
    public var body: some View {
        PrimitiveDayLabel(name: day.name, date: day.date, isSelected: isSelected)
    }
    
}

private struct PrimitiveDayLabel: View {
    
    var name: String
    var date: Date
    var isSelected: Bool
    
    var body: some View {
        Label {
            Text(verbatim: name)
        } icon: {
            let calendarDay = Calendar.current.component(.day, from: date)
            let systemName: String = {
                var name = "\(calendarDay).square"
                if isSelected {
                    name = name.appending(".fill")
                }
                
                return name
            }()
            
            SwiftUI.Image(systemName: systemName)
        }
    }
    
}

struct DayLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        let earlyArrivalEF27Components = DateComponents(
            calendar: .current,
            timeZone: .conventionTimeZone,
            year: 2023,
            month: 9,
            day: 2,
            hour: 12
        )
        
        let earlyArrivalEF27 = earlyArrivalEF27Components.date.unsafelyUnwrapped
        
        PrimitiveDayLabel(name: "Early Arrival", date: earlyArrivalEF27, isSelected: false)
        PrimitiveDayLabel(name: "Early Arrival", date: earlyArrivalEF27, isSelected: true)
    }
    
}
