import EurofurenceApplication
import EurofurenceModelTestDoubles
import UIKit
import XCTest

class BackgroundFetchServiceTests: XCTestCase {
    
    func testSuccessfulRefresh() {
        let refreshService = CapturingRefreshService()
        let backgroundFetchService = BackgroundFetchService(
            refreshService: refreshService
        )
        
        var outputResult: UIBackgroundFetchResult?
        backgroundFetchService.executeFetch { outputResult = $0 }
        
        refreshService.succeedLastRefresh()
        
        XCTAssertEqual(outputResult, UIBackgroundFetchResult.newData)
    }
    
    func testFailingRefresh() {
        let refreshService = CapturingRefreshService()
        let backgroundFetchService = BackgroundFetchService(
            refreshService: refreshService
        )
        
        var outputResult: UIBackgroundFetchResult?
        backgroundFetchService.executeFetch { outputResult = $0 }
        
        refreshService.failLastRefresh()
        
        XCTAssertEqual(outputResult, UIBackgroundFetchResult.failed)
    }

}
