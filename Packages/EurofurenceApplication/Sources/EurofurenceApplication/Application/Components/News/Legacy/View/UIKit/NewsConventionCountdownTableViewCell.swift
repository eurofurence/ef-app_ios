import UIKit

public class NewsConventionCountdownTableViewCell: UITableViewCell, ConventionCountdownComponent {
    
    override public class func registerNib(in tableView: UITableView) {
        registerNib(in: tableView, bundle: .module)
    }

    // MARK: IBOutlets

    @IBOutlet private weak var timeUntilConventionLabel: UILabel! {
        didSet {
            timeUntilConventionLabel.accessibilityIdentifier = "Countdown_DaysRemaining"
        }
    }

    // MARK: ConventionCountdownComponent

    public func setTimeUntilConvention(_ timeUntilConvention: String) {
        timeUntilConventionLabel.text = timeUntilConvention
    }

}
