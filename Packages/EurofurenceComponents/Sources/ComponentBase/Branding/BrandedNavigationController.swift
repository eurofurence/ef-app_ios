import UIKit

public class BrandedNavigationController: UINavigationController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
    }
    
}
