import UIKit

class LinkTableViewCell: UITableViewCell, LinkScene {

    // MARK: Outlets/Actions

    @IBOutlet weak var linkButton: UIButton!

    @IBAction func linkButtonTapped(_ sender: Any) {
        tapHandler?()
    }
    
    // MARK: LinkScene

    func setLinkName(_ linkName: String) {
        linkButton.setTitle(linkName, for: .normal)
    }
    
    private var tapHandler: (() -> Void)?
    func setTapHandler(_ tapHandler: @escaping () -> Void) {
        self.tapHandler = tapHandler
    }

}
