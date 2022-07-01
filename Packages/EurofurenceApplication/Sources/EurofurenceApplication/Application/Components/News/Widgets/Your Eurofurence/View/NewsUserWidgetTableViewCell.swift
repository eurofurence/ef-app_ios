import UIKit

class NewsUserWidgetTableViewCell: UITableViewCell {

    // MARK: Properties

    let standardUserPromptColor = UIColor.userPrompt
    let highlightedUserPromptColor = UIColor.userPromptWithUnreadMessages

    // MARK: IBOutlets

    @IBOutlet weak var standardUserPromptView: UIView! {
        didSet {
            standardUserPromptView.accessibilityIdentifier = "Personalised_UserIcon"
            standardUserPromptView.tintColor = .efTintColor
        }
    }
    
    @IBOutlet weak var highlightedUserPromptView: UIView! {
        didSet {
            highlightedUserPromptView.accessibilityIdentifier = "Personalised_UserHighlightedIcon"
            highlightedUserPromptView.tintColor = .efTintColor
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
    
    func bind<ViewModel>(to viewModel: ViewModel) where ViewModel: YourEurofurenceWidgetViewModel {
        promptLabel.text = viewModel.prompt
        detailedPromptLabel.text = viewModel.supplementaryPrompt
        
        let isHighlightedForAttention = viewModel.isHighlightedForAttention
        standardUserPromptView.isHidden = isHighlightedForAttention
        highlightedUserPromptView.isHidden = !isHighlightedForAttention
        
        let promptColor = isHighlightedForAttention ? highlightedUserPromptColor : standardUserPromptColor
        detailedPromptLabel.textColor = promptColor
    }

}
