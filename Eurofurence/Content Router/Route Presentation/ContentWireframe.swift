import UIKit.UIViewController

public protocol ContentWireframe {
    
    func presentPrimaryContentController(_ viewController: UIViewController)
    func presentDetailContentController(_ viewController: UIViewController)
    func replaceDetailContentController(_ viewController: UIViewController)
    
}
