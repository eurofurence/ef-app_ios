import UIKit

class AboutTheArtTableViewCell: UITableViewCell, AboutTheArtComponent {

    // MARK: IBOutlets

    @IBOutlet weak var componentTitleLabel: UILabel!
    @IBOutlet weak var artDescriptionLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var artworkCaptionLabel: UILabel!

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        isAccessibilityElement = false
        accessibilityElements = [
            componentTitleLabel as Any,
            artDescriptionLabel as Any,
            artworkCaptionLabel as Any
        ]
    }

    // MARK: AboutTheArtComponent

    func setComponentTitle(_ title: String) {
        componentTitleLabel.text = title
    }

    func showAboutTheArtDescription(_ aboutTheArt: String) {
        artDescriptionLabel.text = aboutTheArt
        artDescriptionLabel.isHidden = false
    }

    func showArtPreviewImagePNGData(_ artPreviewImagePNGData: Data) {
        let image = UIImage(data: artPreviewImagePNGData)
        artworkImageView.image = image
        artworkImageView.isHidden = false
    }

    func showArtPreviewCaption(_ caption: String) {
        artworkCaptionLabel.text = caption
        artworkCaptionLabel.isHidden = false
    }

    func hideAboutTheArtDescription() {
        artDescriptionLabel.isHidden = true
    }

    func hideArtPreviewImage() {
        artworkImageView.isHidden = true
    }

    func hideArtPreviewCaption() {
        artworkCaptionLabel.isHidden = true
    }

}
