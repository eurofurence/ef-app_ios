import UIKit

class MapContextualContentViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!

    func setContextualContent(_ content: String) {
        titleLabel.text = content
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let preferredSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        preferredContentSize = preferredSize
    }

}
