import Combine
import UIKit

public class NewsUserWidgetTableViewCell: UITableViewCell {

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
    
    private var subscriptions = Set<AnyCancellable>()

    func bind<ViewModel>(to viewModel: ViewModel) where ViewModel: YourEurofurenceWidgetViewModel {
        viewModel
            .publisher(for: \.prompt)
            .map(Optional.init)
            .assign(to: \.text, on: promptLabel)
            .store(in: &subscriptions)
        
        viewModel
            .publisher(for: \.supplementaryPrompt)
            .map(Optional.init)
            .assign(to: \.text, on: detailedPromptLabel)
            .store(in: &subscriptions)
        
        viewModel
            .publisher(for: \.isHighlightedForAttention)
            .assign(to: \.isHidden, on: standardUserPromptView)
            .store(in: &subscriptions)
        
        viewModel
            .publisher(for: \.isHighlightedForAttention)
            .map({ !$0 })
            .assign(to: \.isHidden, on: highlightedUserPromptView)
            .store(in: &subscriptions)
        
        viewModel
            .publisher(for: \.isHighlightedForAttention)
            .map({ [weak self] in $0 ? self?.highlightedUserPromptColor : self?.standardUserPromptColor })
            .assign(to: \.textColor, on: detailedPromptLabel)
            .store(in: &subscriptions)
    }

}
