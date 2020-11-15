import EurofurenceApplicationSession
import EurofurenceModel
import EventsWidgetLogic
import Foundation.NSURL

struct WidgetRepositoryAdapter: EventsWidgetLogic.EventRepository {
    
    var intent: ViewEventsIntent
    
    func loadEvents(completionHandler: @escaping ([EventsWidgetLogic.Event]) -> Void) {
        let session = EurofurenceSessionBuilder.buildingForEurofurenceApplication().build()
        let eventsService = session.services.events
        
        let favouritesOnly = intent.favouritesOnly?.boolValue ?? false
        let adapterType: EventsAdapter.Type
        
        switch intent.filter {
        case .upcoming:
            adapterType = UpcomingEventsAdapter.self
            
        case .running:
            fallthrough
        default:
            adapterType = RunningEventsAdapter.self
        }

        let adapter = adapterType.init(favouritesOnly: favouritesOnly, completionHandler: completionHandler)
        eventsService.add(adapter)
    }
    
    private struct WidgetEventAdapter: EventsWidgetLogic.Event {
                
        var event: EurofurenceModel.Event
        
        var id: String {
            event.identifier.rawValue
        }
        
        var title: String {
            event.title
        }
        
        var startTime: Date {
            event.startDate
        }
        
    }
    
    private class EventsAdapter: EurofurenceModel.EventsServiceObserver {
        
        let favouritesOnly: Bool
        private let completionHandler: ([EventsWidgetLogic.Event]) -> Void
        
        required init(favouritesOnly: Bool, completionHandler: @escaping ([EventsWidgetLogic.Event]) -> Void) {
            self.favouritesOnly = favouritesOnly
            self.completionHandler = completionHandler
        }
        
        func completeLoad(events: [EurofurenceModel.Event]) {
            let widgetEvents = events.map(WidgetEventAdapter.init(event:))
            completionHandler(widgetEvents)
        }
        
        func eventsDidChange(to events: [EurofurenceModel.Event]) {
            
        }
        
        func runningEventsDidChange(to events: [EurofurenceModel.Event]) {
            
        }
        
        func upcomingEventsDidChange(to events: [EurofurenceModel.Event]) {
            
        }
        
        func favouriteEventsDidChange(_ identifiers: [EventIdentifier]) {
            
        }
        
    }
    
    private class UpcomingEventsAdapter: EventsAdapter {
        
        override func upcomingEventsDidChange(to events: [EurofurenceModel.Event]) {
            
        }
        
    }
    
    private class RunningEventsAdapter: EventsAdapter {
        
        override func runningEventsDidChange(to events: [EurofurenceModel.Event]) {
            
        }
        
    }
    
}
