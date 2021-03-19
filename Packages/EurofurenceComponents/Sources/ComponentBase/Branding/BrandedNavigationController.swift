import UIKit

public class BrandedNavigationController: UINavigationController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            navigationBar.prefersLargeTitles = true
        }
    }
    
}
