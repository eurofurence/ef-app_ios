import EurofurenceApplication
import XCTComponentBase
import XCTest

class SettingsRouteTests: XCTestCase {
    
    func testShowsSettingsViewController() {
        let modalWireframe = CapturingModalWireframe()
        let settingsModuleFactory = StubSettingsModuleFactory()
        let route = SettingsRoute(modalWireframe: modalWireframe, settingsModuleFactory: settingsModuleFactory)
        let routeable = SettingsRouteable(sender: "Unused for this test")
        route.route(routeable)
        
        XCTAssertIdentical(settingsModuleFactory.stubViewController, modalWireframe.presentedModalContentController)
    }
    
    func testUsesSenderAsSourceBarButtonItemForPopoverPresentation() {
        let modalWireframe = CapturingModalWireframe()
        let settingsModuleFactory = StubSettingsModuleFactory()
        let route = SettingsRoute(modalWireframe: modalWireframe, settingsModuleFactory: settingsModuleFactory)
        let sender = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        let routeable = SettingsRouteable(sender: sender)
        route.route(routeable)
        let presentedViewController = modalWireframe.presentedModalContentController
        
        XCTAssertIdentical(sender, presentedViewController?.popoverPresentationController?.barButtonItem)
    }

}
