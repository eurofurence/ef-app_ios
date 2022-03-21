import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class EventWidgetUpdaterTests: XCTestCase {
    
    private var widgetService: CapturingWidgetService!
    private var refreshService: CapturingRefreshService!
    private var eventsService: FakeScheduleRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        widgetService = CapturingWidgetService()
        refreshService = CapturingRefreshService()
        eventsService = FakeScheduleRepository()
    }

    private func setupUpdater() {
        _ = EventWidgetUpdater(
            widgetService: widgetService,
            refreshService: refreshService,
            eventsService: eventsService
        )
    }
    
    func testRequestsUpdateWhenContentIsRefreshed() {
        setupUpdater()
        
        XCTAssertEqual(.unset, widgetService.reloadState, "No widgets should be refreshed when no events have occurred")
        
        refreshService.simulateRefreshBegan()
        
        assertReloadsEventsWidget(afterAction: { refreshService.simulateRefreshFinished() })
    }
    
    func testRequestsUpdateWhenAnyEventTransitionsFromUnfavouriteToFavourite() {
        let event = FakeEvent.random
        event.unfavourite()
        eventsService.allEvents = [event]
        
        setupUpdater()
        
        assertReloadsEventsWidget(afterAction: { event.favourite() })
    }
    
    func testRequestsUpdateWhenAnyEventTransitionsFromFavouriteToUnfavourite() {
        let event = FakeEvent.random
        event.favourite()
        eventsService.allEvents = [event]
        
        setupUpdater()
        
        assertReloadsEventsWidget(afterAction: { event.unfavourite() })
    }
    
    private func assertReloadsEventsWidget(afterAction action: () -> Void, line: UInt = #line) {
        XCTAssertEqual(
            .unset,
            widgetService.reloadState,
            "No widgets should be refreshed before performing the action",
            line: line
        )
        
        action()
        
        let expectedWidgetsToBeRefreshed = Set(["org.eurofurence.EventsWidget"])
        
        XCTAssertEqual(
            .reloadRequested(widgets: expectedWidgetsToBeRefreshed),
            widgetService.reloadState,
            "Widgets should be refreshed after performing the action",
            line: line
        )
    }

}
