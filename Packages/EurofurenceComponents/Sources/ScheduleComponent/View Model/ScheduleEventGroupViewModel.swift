import Foundation

public struct ScheduleEventGroupViewModel {

    public var title: String
    public var events: [ScheduleEventViewModelProtocol]
    
    public init(title: String, events: [ScheduleEventViewModelProtocol]) {
        self.title = title
        self.events = events
    }

}
