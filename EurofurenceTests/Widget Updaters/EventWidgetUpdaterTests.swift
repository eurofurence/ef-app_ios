import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class EventWidgetUpdaterTests: XCTestCase {

    func testRequestsUpdateWhenContentIsRefreshed() {
        let widgetService = CapturingWidgetService()
        let refreshService = CapturingRefreshService()
        let eventsService = FakeEventsService()
        _ = EventWidgetUpdater(
            widgetService: widgetService,
            refreshService: refreshService,
            eventsService: eventsService
        )
        
        XCTAssertEqual(.unset, widgetService.reloadState, "No widgets should be refreshed when no events have occurred")
        
        refreshService.simulateRefreshBegan()
        
        XCTAssertEqual(.unset, widgetService.reloadState, "No widgets should be refreshed until a refresh concludes")
        
        refreshService.simulateRefreshFinished()
        
        let expectedWidgetsToBeRefreshed = Set(arrayLiteral: "org.eurofurence.EventsWidget")
        
        XCTAssertEqual(
            .reloadRequested(widgets: expectedWidgetsToBeRefreshed),
            widgetService.reloadState,
            "Refreshing content should reload the events widget"
        )
    }
    
    func testRequestsUpdateWhenAnyEventTransitionsFromUnfavouriteToFavourite() {
        let widgetService = CapturingWidgetService()
        let refreshService = CapturingRefreshService()
        let eventsService = FakeEventsService()
        let event = FakeEvent.random
        event.unfavourite()
        eventsService.allEvents = [event]
        
        _ = EventWidgetUpdater(
            widgetService: widgetService,
            refreshService: refreshService,
            eventsService: eventsService
        )
        
        XCTAssertEqual(
            .unset,
            widgetService.reloadState,
            "No widgets should be refreshed when initially subscribing to events"
        )
        
        event.favourite()
        
        let expectedWidgetsToBeRefreshed = Set(arrayLiteral: "org.eurofurence.EventsWidget")
        
        XCTAssertEqual(
            .reloadRequested(widgets: expectedWidgetsToBeRefreshed),
            widgetService.reloadState,
            "An event changing favourite state should induce a widget refresh"
        )
    }
    
    func testRequestsUpdateWhenAnyEventTransitionsFromFavouriteToUnfavourite() {
        let widgetService = CapturingWidgetService()
        let refreshService = CapturingRefreshService()
        let eventsService = FakeEventsService()
        let event = FakeEvent.random
        event.favourite()
        eventsService.allEvents = [event]
        
        _ = EventWidgetUpdater(
            widgetService: widgetService,
            refreshService: refreshService,
            eventsService: eventsService
        )
        
        XCTAssertEqual(
            .unset,
            widgetService.reloadState,
            "No widgets should be refreshed when initially subscribing to events"
        )
        
        event.unfavourite()
        
        let expectedWidgetsToBeRefreshed = Set(arrayLiteral: "org.eurofurence.EventsWidget")
        
        XCTAssertEqual(
            .reloadRequested(widgets: expectedWidgetsToBeRefreshed),
            widgetService.reloadState,
            "An event changing favourite state should induce a widget refresh"
        )
    }

}
