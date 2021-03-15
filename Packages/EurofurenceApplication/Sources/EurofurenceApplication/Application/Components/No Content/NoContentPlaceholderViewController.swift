import UIKit

class NoContentPlaceholderViewController: UIViewController {
    
    static func fromStoryboard() -> NoContentPlaceholderViewController {
        let storyboard = UIStoryboard(name: "NoContentPlaceholderViewController", bundle: .module)
        return storyboard.instantiate(NoContentPlaceholderViewController.self)
    }
    
    @IBOutlet private weak var placeholderImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderImageView.tintColor = .placeholder
    }
    
}
