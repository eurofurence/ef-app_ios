import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceComponentBase

class ShowMapFromMapsTests: XCTestCase {
    
    func testShowsMap() {
        let router = FakeContentRouter()
        let navigator = ShowMapFromMaps(router: router)
        let map = MapIdentifier.random
        navigator.mapsComponentDidSelectMap(identifier: map)
        
        router.assertRouted(to: MapContentRepresentation(identifier: map))
    }

}
