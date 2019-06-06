import UIKit

class NewsConventionCountdownTableViewCell: UITableViewCell, ConventionCountdownComponent {

    // MARK: IBOutlets

    @IBOutlet private weak var timeUntilConventionLabel: UILabel!

    // MARK: ConventionCountdownComponent

    func setTimeUntilConvention(_ timeUntilConvention: String) {
        timeUntilConventionLabel.text = timeUntilConvention
    }

}
