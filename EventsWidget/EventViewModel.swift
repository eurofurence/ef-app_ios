import Foundation

struct EventViewModel: Identifiable {
    
    let id = UUID()
    var formattedStartTime: String
    var formattedEndTime: String
    var eventTitle: String
    var eventLocation: String
    
}
