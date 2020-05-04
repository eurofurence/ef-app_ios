import Eurofurence
import XCTest

class WebContentRouteTests: XCTestCase {
    
    func testShowsModalWebModule() {
        let webModuleProviding = StubWebMobuleProviding()
        let modalWireframe = CapturingModalWireframe()
        let route = WebContentRoute(
            webModuleProviding: webModuleProviding,
            modalWireframe: modalWireframe
        )
        
        let url = URL.random
        let content = WebContentRepresentation(url: url)
        route.route(content)
        
        let presentedWebModule = webModuleProviding.producedWebModules[url]
        
        XCTAssertNotNil(presentedWebModule)
        XCTAssertEqual(presentedWebModule, modalWireframe.presentedModalContentController)
    }

}
