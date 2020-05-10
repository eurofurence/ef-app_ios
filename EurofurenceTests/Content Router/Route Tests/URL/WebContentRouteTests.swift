import Eurofurence
import XCTest

class WebContentRouteTests: XCTestCase {
    
    func testShowsModalWebModule() {
        let webComponentFactory = StubWebMobuleProviding()
        let modalWireframe = CapturingModalWireframe()
        let route = WebContentRoute(
            webComponentFactory: webComponentFactory,
            modalWireframe: modalWireframe
        )
        
        let url = URL.random
        let content = WebContentRepresentation(url: url)
        route.route(content)
        
        let presentedWebModule = webComponentFactory.producedWebModules[url]
        
        XCTAssertNotNil(presentedWebModule)
        XCTAssertEqual(presentedWebModule, modalWireframe.presentedModalContentController)
    }

}
