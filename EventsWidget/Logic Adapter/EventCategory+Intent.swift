import EurofurenceIntentDefinitions
import EventsWidgetLogic

extension EventCategory {
    
    init(filter: EventFilter) {
        switch filter {
        case .running:
            self = .running
            
        case .upcoming:
            fallthrough
        default:
            self = .upcoming
        }
    }
    
}
