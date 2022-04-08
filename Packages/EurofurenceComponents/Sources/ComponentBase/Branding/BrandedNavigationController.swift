import UIKit

public class BrandedNavigationController: UINavigationController {
    
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        tabBarItem = rootViewController.tabBarItem
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
    }
    
}
