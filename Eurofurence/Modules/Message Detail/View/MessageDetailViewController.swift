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
        
        messageDetailScrollView.isHidden = true
        errorContainerView.isHidden = true
        delegate?.messageDetailSceneDidLoad()
    }

    // MARK: MessageDetailScene

    var delegate: MessageDetailSceneDelegate?
    
    func showLoadingIndicator() {
        activityIndicatorView.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicatorView.stopAnimating()
    }

    func setMessageDetailTitle(_ title: String) {
        super.title = title
    }
    
    func showMessage(viewModel: MessageDetailViewModel) {
        errorContainerView.isHidden = true
        messageDetailScrollView.isHidden = false
        messageSubjectLabel.text = viewModel.subject
        messageContentsTextView.text = viewModel.contents
    }
    
    func showError(viewModel: MessageDetailErrorViewModel) {
        errorViewModel = viewModel
        errorContainerView.isHidden = false
        messageDetailScrollView.isHidden = true
        errorDescriptionLabel.text = viewModel.errorDescription
    }

    func addMessageComponent(with binder: MessageComponentBinder) {
        
    }

}
