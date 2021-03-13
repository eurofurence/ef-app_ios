import EurofurenceModel

public struct EventWidgetUpdater {
    
    public init(widgetService: WidgetService, refreshService: RefreshService, eventsService: EventsService) {
        let reloadWidget = ReloadWidget(widgetService: widgetService)
        let reloadWhenContentRefreshes = ReloadWhenRefreshFinishes(reloadWidget: reloadWidget)
        refreshService.add(reloadWhenContentRefreshes)
        
        let reloadWhenEventFavouriteStateChanges = ReloadWhenEventFavouriteStateChanges(reloadWidget: reloadWidget)
        eventsService.add(reloadWhenEventFavouriteStateChanges)
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
    
    private class ReloadWhenEventFavouriteStateChanges: EventsServiceObserver, EventObserver {
        
        private let reloadWidget: ReloadWidget
        private var isSubscribingToEvents = false
        
        init(reloadWidget: ReloadWidget) {
            self.reloadWidget = reloadWidget
        }
        
        func eventsDidChange(to events: [Event]) {
            isSubscribingToEvents = true
            
            for event in events {
                event.add(self)
            }
            
            isSubscribingToEvents = false
        }
        
        func runningEventsDidChange(to events: [Event]) {
            
        }
        
        func upcomingEventsDidChange(to events: [Event]) {
            
        }
        
        func favouriteEventsDidChange(_ identifiers: [EventIdentifier]) {
            
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
