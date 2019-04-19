import UIKit

class EventFeedbackViewController: UIViewController, EventFeedbackScene {
    
    // MARK: UIKit Stuff
    
    @IBOutlet private weak var eventTitleLabel: UILabel!
    @IBOutlet private weak var eventSubtitleLabel: UILabel!
    @IBOutlet private weak var childContainer: UIView!
    
    private var embeddedChild: UIViewController?
    
    @IBAction private func cancelFeedback(_ sender: Any) {
        viewModel?.cancelFeedback()
    }
    
    @IBAction private func submitFeedback(_ sender: Any) {
        viewModel?.submitFeedback()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.eventFeedbackSceneDidLoad()
    }
    
    private func swapEmbeddedViewController(to newChild: UIViewController) {
        unembedExistingChildController()
        embedNewChildController(newChild)
    }
    
    private func unembedExistingChildController() {
        if let embeddedChild = embeddedChild {
            embeddedChild.willMove(toParent: nil)
            embeddedChild.view.removeFromSuperview()
            embeddedChild.removeFromParent()
            embeddedChild.didMove(toParent: nil)
        }
    }
    
    private func embedNewChildController(_ newChild: UIViewController) {
        newChild.willMove(toParent: self)
        addChild(newChild)
        childContainer.addSubview(newChild.view)
        
        NSLayoutConstraint.activate([
            newChild.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newChild.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newChild.view.topAnchor.constraint(equalTo: view.topAnchor),
            newChild.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        newChild.didMove(toParent: self)
        
        embeddedChild = newChild
    }
    
    // MARK: EventFeedbackScene
    
    private var delegate: EventFeedbackSceneDelegate?
    func setDelegate(_ delegate: EventFeedbackSceneDelegate) {
        self.delegate = delegate
    }
    
    private var viewModel: EventFeedbackViewModel?
    func bind(_ viewModel: EventFeedbackViewModel) {
        self.viewModel = viewModel
        
        eventTitleLabel.text = viewModel.eventTitle
        eventSubtitleLabel.text = [viewModel.eventDayAndTime, viewModel.eventLocation, viewModel.eventHosts].joined(separator: "\n")
    }
    
    func showFeedbackForm() {
        
    }
    
    func showFeedbackSubmissionInProgress() {
        
    }
    
    func hideFeedbackSubmissionProgress() {
        
    }
    
    func showFeedbackSubmissionSuccessful() {
        
    }
    
    func showFeedbackSubmissionFailedPrompt() {
        
    }
    
}
