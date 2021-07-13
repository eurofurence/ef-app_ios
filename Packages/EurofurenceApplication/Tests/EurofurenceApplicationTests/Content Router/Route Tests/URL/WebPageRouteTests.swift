import ComponentBase
import EurofurenceApplication
import XCTComponentBase
import XCTest

class WebPageRouteTests: XCTestCase {
    
    func testShowsModalWebModule() {
        let webComponentFactory = StubWebComponentFactory()
        let modalWireframe = CapturingModalWireframe()
        let route = WebPageRoute(
            webComponentFactory: webComponentFactory,
            modalWireframe: modalWireframe
        )
        
        let url = URL.random
        let content = WebRouteable(url: url)
        route.route(content)
        
        let presentedWebModule = webComponentFactory.producedWebModules[url]
        
        XCTAssertNotNil(presentedWebModule)
        XCTAssertEqual(presentedWebModule, modalWireframe.presentedModalContentController)
    }

}
