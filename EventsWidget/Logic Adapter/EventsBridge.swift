import EurofurenceModel
import EventsWidgetLogic
import Foundation.NSDate

class EventsBridge {
    
    private var allEvents: [EurofurenceModel.Event] = []
    
    private struct WidgetEventAdapter: EventsWidgetLogic.Event {
                
        var event: EurofurenceModel.Event
        
        var id: String {
            event.identifier.rawValue
        }
        
        var title: String {
            event.title
        }
        
        var location: String {
            event.room.name
        }
        
        var startTime: Date {
            event.startDate
        }
        
        var endTime: Date {
            event.endDate
        }
        
        var deepLinkingContentURL: URL {
            event.contentURL
        }
        
    }
    
}


// MARK: - Acquiring Events from model

extension EventsBridge: EurofurenceModel.EventsServiceObserver {
    
    func eventsDidChange(to events: [EurofurenceModel.Event]) {
        allEvents = events
    }
    
    func runningEventsDidChange(to events: [EurofurenceModel.Event]) {
        
    }
    
    func upcomingEventsDidChange(to events: [EurofurenceModel.Event]) {
        
    }
    
    func favouriteEventsDidChange(_ identifiers: [EventIdentifier]) {
        
    }
    
}


// MARK: - Adapting widget repository

extension EventsBridge: EventsWidgetLogic.EventRepository {
    
    func loadEvents(completionHandler: @escaping ([EventsWidgetLogic.Event]) -> Void) {
        let widgetEvents = allEvents.map(WidgetEventAdapter.init(event:))
        completionHandler(widgetEvents)
    }
    
}
