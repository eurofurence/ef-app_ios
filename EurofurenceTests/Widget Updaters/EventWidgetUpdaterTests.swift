import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class EventWidgetUpdaterTests: XCTestCase {

    func testRequestsUpdateWhenContentIsRefreshed() {
        let widgetService = CapturingWidgetService()
        let refreshService = CapturingRefreshService()
        _ = EventWidgetUpdater(widgetService: widgetService, refreshService: refreshService)
        
        let expectedWidgetsToBeRefreshed = Set(arrayLiteral: "org.eurofurence.EventsWidget")
        
        XCTAssertEqual(.unset, widgetService.reloadState, "No widgets should be refreshed when no events have occurred")
        
        refreshService.simulateRefreshBegan()
        
        XCTAssertEqual(.unset, widgetService.reloadState, "No widgets should be refreshed until a refresh concludes")
        
        refreshService.simulateRefreshFinished()
        
        XCTAssertEqual(
            .reloadRequested(widgets: expectedWidgetsToBeRefreshed),
            widgetService.reloadState,
            "Refreshing content should reload the events widget"
        )
    }

}
