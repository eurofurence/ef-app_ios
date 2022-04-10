import UIKit

public class NewsUserWidgetTableViewCell: UITableViewCell, UserWidgetComponent {

    // MARK: Properties

    private let standardUserPromptColor = UIColor.userPrompt
    private let highlightedUserPromptColor = UIColor.userPromptWithUnreadMessages

    // MARK: IBOutlets

    @IBOutlet private weak var standardUserPromptView: UIView! {
        didSet {
            standardUserPromptView.accessibilityIdentifier = "Personalised_UserIcon"
        }
    }
    
    @IBOutlet private weak var highlightedUserPromptView: UIView! {
        didSet {
            highlightedUserPromptView.accessibilityIdentifier = "Personalised_UserHighlightedIcon"
        }
    }
    
    @IBOutlet private weak var promptLabel: UILabel! {
        didSet {
            promptLabel.accessibilityIdentifier = "Personalised_Prompt"
        }
    }
    
    @IBOutlet private weak var detailedPromptLabel: UILabel! {
        didSet {
            detailedPromptLabel.accessibilityIdentifier = "Personalised_SupplementaryPrompt"
        }
    }
    
    override public class func registerNib(in tableView: UITableView) {
        registerNib(in: tableView, bundle: .module)
    }

    // MARK: UserWidgetComponent

    public func setPrompt(_ prompt: String) {
        promptLabel.text = prompt
    }

    public func setDetailedPrompt(_ detailedPrompt: String) {
        detailedPromptLabel.text = detailedPrompt
    }

    public func showHighlightedUserPrompt() {
        highlightedUserPromptView.isHidden = false
        detailedPromptLabel.textColor = highlightedUserPromptColor
    }

    public func hideHighlightedUserPrompt() {
        highlightedUserPromptView.isHidden = true
    }

    public func showStandardUserPrompt() {
        standardUserPromptView.isHidden = false
        detailedPromptLabel.textColor = standardUserPromptColor
    }

    public func hideStandardUserPrompt() {
        standardUserPromptView.isHidden = true
    }

}
