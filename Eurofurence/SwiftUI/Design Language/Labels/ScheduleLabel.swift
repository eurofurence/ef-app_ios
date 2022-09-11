import SwiftUI

struct ScheduleLabel: View {
    
    private var isSelected: Bool
    
    init(isSelected: Bool = false) {
        self.isSelected = isSelected
    }
    
    var body: some View {
        Label {
            Text("Schedule")
        } icon: {
            Image(systemName: "calendar")
        }
    }
    
}

struct ScheduleLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        ScheduleLabel()
            .previewLayout(.sizeThatFits)
        
        ScheduleLabel(isSelected: true)
            .previewLayout(.sizeThatFits)
    }
    
}
