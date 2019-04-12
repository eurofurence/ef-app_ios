import UIKit.UICollectionViewCell

class MessageBubbleCollectionViewCell: UICollectionViewCell, MessageComponent {

    // MARK: IBOutlets

    @IBOutlet weak var bubbleBackgroundView: MessageBubbleBackgroundView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    // MARK: MessageComponent

    func setMessageSubject(_ subject: String) {
        subjectLabel.text = subject
    }

    func setMessageContents(_ contents: String) {
        messageLabel.text = contents
    }

    // MARK: Overrides

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let width = attributes.frame.width
        let targetSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let height = systemLayoutSizeFitting(targetSize).height

        var frame = attributes.frame
        frame.size = CGSize(width: width, height: height)
        attributes.frame = frame

        return attributes
    }

}
