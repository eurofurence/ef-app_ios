import EurofurenceApplication
import UIKit

class StubSettingsModuleFactory: SettingsModuleFactory {
    
    let stubViewController = UIViewController()
    func makeSettingsModule() -> UIViewController {
        stubViewController
    }
    
}
