import EurofurenceModel
import XCTest

class WhenDeletingMap_AfterSuccessfulSync_ApplicationShould: XCTestCase {

    func testUpdateDelegateWithoutDeletedMap() {
        var response = ModelCharacteristics.randomWithoutDeletions
        let context = EurofurenceSessionTestBuilder().build()
        let delegate = CapturingMapsObserver()
        context.mapsService.add(delegate)
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let mapToDelete = response.maps.changed.randomElement()
        response.maps.changed = response.maps.changed.filter({ $0.identifier != mapToDelete.element.identifier })
        let expected = Set(response.maps.changed.identifiers)
        response.maps.changed.removeAll()
        response.maps.deleted.append(mapToDelete.element.identifier)
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let actual = Set(delegate.capturedMaps.map(\.identifier.rawValue))

        XCTAssertEqual(expected, actual,
                       "Should have removed map \(mapToDelete.element.identifier)")
    }

}
