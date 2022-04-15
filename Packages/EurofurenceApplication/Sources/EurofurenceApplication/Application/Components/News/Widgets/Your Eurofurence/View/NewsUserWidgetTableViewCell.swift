import UIKit

public class NewsUserWidgetTableViewCell: UITableViewCell {

    // MARK: Properties

    let standardUserPromptColor = UIColor.userPrompt
    let highlightedUserPromptColor = UIColor.userPromptWithUnreadMessages

    // MARK: IBOutlets

    @IBOutlet weak var standardUserPromptView: UIView! {
        didSet {
            standardUserPromptView.accessibilityIdentifier = "Personalised_UserIcon"
        }
    }
    
    @IBOutlet weak var highlightedUserPromptView: UIView! {
        didSet {
            highlightedUserPromptView.accessibilityIdentifier = "Personalised_UserHighlightedIcon"
        }
    }
    
    @IBOutlet weak var promptLabel: UILabel! {
        didSet {
            promptLabel.accessibilityIdentifier = "Personalised_Prompt"
        }
    }
    
    @IBOutlet weak var detailedPromptLabel: UILabel! {
        didSet {
            detailedPromptLabel.accessibilityIdentifier = "Personalised_SupplementaryPrompt"
        }
    }
    
    override public class func registerNib(in tableView: UITableView) {
        registerNib(in: tableView, bundle: .module)
    }

}
