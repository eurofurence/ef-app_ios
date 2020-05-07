import UIKit.UIViewController

class MessageDetailViewController: UIViewController, MessageDetailScene {

    // MARK: IBOutlets

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var messageDetailScrollView: UIScrollView!
    @IBOutlet private weak var messageSubjectLabel: UILabel!
    @IBOutlet private weak var messageContentsTextView: UITextView!

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageContentsTextView.contentInset = .zero
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
        messageSubjectLabel.text = viewModel.subject
        messageContentsTextView.text = viewModel.contents
    }
    
    func showError(viewModel: MessageDetailErrorViewModel) {
        
    }

    func addMessageComponent(with binder: MessageComponentBinder) {
        
    }

}
