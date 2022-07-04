import UIKit

public class NoContentPlaceholderViewController: UIViewController {
    
    public static func fromStoryboard() -> NoContentPlaceholderViewController {
        let storyboard = UIStoryboard(name: "NoContentPlaceholderViewController", bundle: .module)
        return storyboard.instantiate(NoContentPlaceholderViewController.self)
    }
    
    @IBOutlet private weak var placeholderImageView: UIImageView! {
        didSet {
            placeholderImageView.accessibilityIdentifier = "org.eurofurence.NoContentPlaceholder"
        }
    }
    
}
