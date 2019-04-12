import UIKit

class DealerAboutTheArtistTableViewCell: UITableViewCell, DealerAboutTheArtistComponent {

    // MARK: Properties

    @IBOutlet weak var componentTitleLabel: UILabel!
    @IBOutlet weak var artistDescriptionLabel: UILabel!

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        isAccessibilityElement = false
        accessibilityElements = [
            componentTitleLabel as Any,
            artistDescriptionLabel as Any
        ]
    }

    // MARK: DealerAboutTheArtistComponent

    func setAboutTheArtistTitle(_ title: String) {
        componentTitleLabel.text = title
    }

    func setArtistDescription(_ artistDescription: String) {
        artistDescriptionLabel.text = artistDescription
    }

}
