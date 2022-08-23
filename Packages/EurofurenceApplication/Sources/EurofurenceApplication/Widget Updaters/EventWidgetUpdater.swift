import EurofurenceModel

public struct EventWidgetUpdater {
    
    private let widgetSchedule: Schedule
    
    public init(widgetService: WidgetService, refreshService: RefreshService, eventsService: ScheduleRepository) {
        let reloadWidget = ReloadWidget(widgetService: widgetService)
        let reloadWhenContentRefreshes = ReloadWhenRefreshFinishes(reloadWidget: reloadWidget)
        refreshService.add(reloadWhenContentRefreshes)
        
        widgetSchedule = eventsService.loadSchedule(tag: "Widget")
        widgetSchedule.setDelegate(WidgetScheduleDelegate(reloadWidget: reloadWidget))
    }
    
    private struct ReloadWidget {
        
        let widgetService: WidgetService
        
        func reloadNow() {
            widgetService.reloadWidgets(identifiers: Set(["org.eurofurence.EventsWidget"]))
        }
        
    }
    
    private struct ReloadWhenRefreshFinishes: RefreshServiceObserver {
        
        let reloadWidget: ReloadWidget
        
        func refreshServiceDidBeginRefreshing() {
            
        }
        
        func refreshServiceDidFinishRefreshing() {
            reloadWidget.reloadNow()
        }
        
    }
    
    private class WidgetScheduleDelegate: ScheduleDelegate, EventObserver {
        
        private let reloadWidget: ReloadWidget
        private var isSubscribingToEvents = false
        
        init(reloadWidget: ReloadWidget) {
            self.reloadWidget = reloadWidget
        }
        
        func scheduleEventsDidChange(to events: [Event]) {
            isSubscribingToEvents = true
            
            for event in events {
                event.add(self)
            }
            
            isSubscribingToEvents = false
        }
        
        func eventDaysDidChange(to days: [Day]) {
            
        }
        
        func currentEventDayDidChange(to day: Day?) {
            
        }
        
        func scheduleSpecificationChanged(to newSpecification: AnySpecification<Event>) {
            
        }
        
        func eventDidBecomeFavourite(_ event: Event) {
            requestWidgetReload()
        }
        
        func eventDidBecomeUnfavourite(_ event: Event) {
            requestWidgetReload()
        }
        
        private func requestWidgetReload() {
            if isSubscribingToEvents == false {
                reloadWidget.reloadNow()
            }
        }
        
    }
    
}
