import EurofurenceApplication
import UIKit

class StubSettingsComponentFactory: SettingsComponentFactory {
    
    let stubViewController = UIViewController()
    func makeSettingsModule() -> UIViewController {
        stubViewController
    }
    
}
