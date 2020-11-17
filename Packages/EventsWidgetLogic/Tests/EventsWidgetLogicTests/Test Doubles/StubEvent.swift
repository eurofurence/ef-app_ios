import EventsWidgetLogic
import Foundation

struct StubEvent: Event {
    
    var id: String
    var title: String
    var location: String
    var startTime: Date
    var endTime: Date
    var deepLinkingContentURL: URL = URL(string: "https://\(Int.random(in: 0...100))")!
    
}
