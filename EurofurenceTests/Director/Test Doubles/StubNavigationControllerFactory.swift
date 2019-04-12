@testable import Eurofurence
import EurofurenceModel
import UIKit.UINavigationController

struct StubNavigationControllerFactory: NavigationControllerFactory {

    func makeNavigationController() -> UINavigationController {
        return CapturingNavigationController()
    }

}
