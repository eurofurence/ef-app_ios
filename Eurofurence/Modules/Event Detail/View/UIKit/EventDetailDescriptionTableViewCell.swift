import UIKit

class EventDetailDescriptionTableViewCell: UITableViewCell, EventDescriptionComponent {

    // MARK: IBOutlets

    @IBOutlet private weak var eventDescriptionTextView: UITextView!

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()
        eventDescriptionTextView.textContainer.lineFragmentPadding = 0
    }

    // MARK: EventDescriptionComponent

    func setEventDescription(_ eventDescription: NSAttributedString) {
        eventDescriptionTextView.attributedText = eventDescription
    }

}
