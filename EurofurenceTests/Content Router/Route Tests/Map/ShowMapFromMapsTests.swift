import Eurofurence
import EurofurenceModel
import XCTest

class ShowMapFromMapsTests: XCTestCase {
    
    func testShowsMap() {
        let router = FakeContentRouter()
        let navigator = ShowMapFromMaps(router: router)
        let map = MapIdentifier.random
        navigator.mapsModuleDidSelectMap(identifier: map)
        
        router.assertRouted(to: MapContentRepresentation(identifier: map))
    }

}
