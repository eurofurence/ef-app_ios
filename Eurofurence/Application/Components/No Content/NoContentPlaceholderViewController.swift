import UIKit

class NoContentPlaceholderViewController: UIViewController {
    
    static func fromStoryboard() -> NoContentPlaceholderViewController {
        let storyboard = UIStoryboard(name: "NoContentPlaceholderViewController", bundle: nil)
        return storyboard.instantiate(NoContentPlaceholderViewController.self)
    }
    
}
