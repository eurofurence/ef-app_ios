import UIKit.UINavigationController

struct PlatformNavigationControllerFactory: NavigationControllerFactory {

    func makeNavigationController() -> UINavigationController {
        return UINavigationController()
    }

}
