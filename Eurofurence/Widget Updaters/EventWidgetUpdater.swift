import EurofurenceModel

public struct EventWidgetUpdater {
    
    public init(widgetService: WidgetService, refreshService: RefreshService) {
        let refresher = ReloadEventsWidgetWhenRefreshFinishes(widgetService: widgetService)
        refreshService.add(refresher)
    }
    
    private struct ReloadEventsWidgetWhenRefreshFinishes: RefreshServiceObserver {
        
        let widgetService: WidgetService
        
        func refreshServiceDidBeginRefreshing() {
            
        }
        
        func refreshServiceDidFinishRefreshing() {
            widgetService.reloadWidgets(identifiers: Set(arrayLiteral: "org.eurofurence.EventsWidget"))
        }
        
    }
    
}
