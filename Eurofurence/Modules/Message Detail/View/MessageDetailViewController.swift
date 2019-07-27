import UIKit.UIViewController

class MessageDetailViewController: UITableViewController, MessageDetailScene {

    // MARK: IBOutlets

    @IBOutlet private weak var messageSubjectLabel: UILabel!
    @IBOutlet private weak var messageContentsTextView: UITextView!

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.messageDetailSceneDidLoad()
    }

    // MARK: MessageDetailScene

    var delegate: MessageDetailSceneDelegate?

    func setMessageDetailTitle(_ title: String) {
        super.title = title
    }

    func addMessageComponent(with binder: MessageComponentBinder) {
        binder.bind(MessageBinder(subjectLabel: messageSubjectLabel, contentsTextView: messageContentsTextView))
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    // MARK: Binding

    private struct MessageBinder: MessageComponent {

        var subjectLabel: UILabel
        var contentsTextView: UITextView

        func setMessageSubject(_ subject: String) {
            subjectLabel.text = subject
        }
        
        func setMessageContents(_ contents: String) {
            contentsTextView.text = contents
        }

    }

}
