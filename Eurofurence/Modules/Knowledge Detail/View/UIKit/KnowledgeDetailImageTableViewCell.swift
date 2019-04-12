import UIKit

class KnowledgeDetailImageTableViewCell: UITableViewCell, KnowledgeEntryImageScene {

    // MARK: Properties

    @IBOutlet weak var entryImageView: UIImageView!

    // MARK: KnowledgeEntryImageScene

    func showImagePNGData(_ data: Data) {
        entryImageView.image = UIImage(data: data)
    }

}
