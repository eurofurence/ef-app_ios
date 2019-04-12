import UIKit

class LinkTableViewCell: UITableViewCell, LinkScene {

    // MARK: IBOutlets

    @IBOutlet weak var linkButton: UIButton!

    // MARK: LinkScene

    func setLinkName(_ linkName: String) {
        linkButton.setTitle(linkName, for: .normal)
    }

}
