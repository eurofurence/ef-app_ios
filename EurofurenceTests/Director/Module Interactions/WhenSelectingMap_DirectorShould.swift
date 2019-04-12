@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSelectingMap_DirectorShould: XCTestCase {

    func testShowTheMapDetailModuleForTheSelectedMapIdentifier() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let mapsNavigationController = context.navigationController(for: context.mapsModule.stubInterface)
        let map = MapIdentifier.random
        context.mapsModule.simulateDidSelectMap(map)

        XCTAssertEqual(context.mapDetailModule.stubInterface, mapsNavigationController?.topViewController)
        XCTAssertEqual(map, context.mapDetailModule.capturedModel)
    }

}
