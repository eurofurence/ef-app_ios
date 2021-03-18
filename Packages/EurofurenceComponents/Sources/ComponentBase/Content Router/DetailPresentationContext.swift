import UIKit

public enum DetailPresentationContext {
    case show
    case replace
}

// MARK: - DetailPresentationContext Revealing

extension DetailPresentationContext {
    
    func reveal(_ viewController: UIViewController, in navigationController: UINavigationController) {
        guard navigationController.viewControllers.contains(viewController) == false else { return }
        
        switch self {
        case .show:
            navigationController.pushViewController(viewController, animated: UIView.areAnimationsEnabled)
            
        case .replace:
            navigationController.setViewControllers([viewController], animated: false)
        }
    }
    
}
