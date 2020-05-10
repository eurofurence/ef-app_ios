import UIKit

class MapContextualContentViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!

    func setContextualContent(_ content: String) {
        titleLabel.text = content
        preferredContentSize = view.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
    }

}
