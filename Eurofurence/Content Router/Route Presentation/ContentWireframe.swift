import UIKit.UIViewController

public protocol ContentWireframe {
    
    func presentMasterContentController(_ viewController: UIViewController)
    func presentDetailContentController(_ viewController: UIViewController)
    
}
