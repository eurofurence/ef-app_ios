import UIKit.UIViewController

class MessageDetailViewController: UIViewController, MessageDetailScene {

    // MARK: IBOutlets

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var messageDetailScrollView: UIScrollView!
    @IBOutlet private weak var messageSubjectLabel: UILabel!
    @IBOutlet private weak var messageContentsTextView: UITextView!
    @IBOutlet private weak var errorContainerView: UIView!
    @IBOutlet private weak var errorDescriptionLabel: UILabel!
    @IBOutlet private weak var tryAgainButton: UIButton!
    
    // MARK: IBActions
    
    private var errorViewModel: MessageDetailErrorViewModel?
    
    @IBAction private func tryLoadingMessageAgain(_ sender: Any) {
        errorViewModel?.retry()
    }
    
    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tryAgainButton.setTitle(.tryAgain, for: .normal)
        
        hideDetail()
        hideError()
        delegate?.messageDetailSceneDidLoad()
    }

    // MARK: MessageDetailScene

    var delegate: MessageDetailSceneDelegate?
    
    func showLoadingIndicator() {
        activityIndicatorView.startAnimating()
        
        animate {
            self.hideDetail()
            self.hideError()
        }
    }
    
    func hideLoadingIndicator() {
        activityIndicatorView.stopAnimating()
    }

    func setMessageDetailTitle(_ title: String) {
        self.title = title
    }
    
    func showMessage(viewModel: MessageDetailViewModel) {
        animate {
            self.hideError()
            self.showDetail()
            self.messageSubjectLabel.text = viewModel.subject
            self.messageContentsTextView.attributedText = viewModel.contents
        }
    }
    
    func showError(viewModel: MessageDetailErrorViewModel) {
        errorViewModel = viewModel
        
        animate {
            self.showError()
            self.hideDetail()
            self.errorDescriptionLabel.text = viewModel.errorDescription
        }
    }
    
    // MARK: Updating view state
    
    private func hideDetail() {
        messageDetailScrollView.alpha = 0
    }
    
    private func showDetail() {
        messageDetailScrollView.alpha = 1
    }
    
    private func hideError() {
        errorContainerView.alpha = 0
    }
    
    private func showError() {
        errorContainerView.alpha = 1
    }
    
    private func animate(_ changes: @escaping () -> Void) {
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: 0.2, animations: changes)
        } else {
            changes()
        }
    }

}
