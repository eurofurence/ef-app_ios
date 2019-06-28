import UIKit

class SaveTabOrderWhenCustomizationFinishes: NSObject, UITabBarControllerDelegate {
    
    private let orderingPolicy: ModuleOrderingPolicy
    
    init(orderingPolicy: ModuleOrderingPolicy) {
        self.orderingPolicy = orderingPolicy
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didEndCustomizing viewControllers: [UIViewController], changed: Bool) {
        orderingPolicy.saveOrder(viewControllers)
    }
    
}
