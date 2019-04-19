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
        embed(newChild)
    }
    
    private func unembedExistingChildController() {
        if let embeddedChild = embeddedChild {
            embeddedChild.willMove(toParent: nil)
            embeddedChild.view.removeFromSuperview()
            embeddedChild.removeFromParent()
            embeddedChild.didMove(toParent: nil)
        }
    }
    
    private func embed(_ newChild: UIViewController) {
        newChild.willMove(toParent: self)
        addChild(newChild)
        embedChildView(newChild.view)
        newChild.didMove(toParent: self)
        
        embeddedChild = newChild
    }
    
    fileprivate func embedChildView(_ newChild: UIView) {
        childContainer.addSubview(newChild)
        newChild.frame = childContainer.bounds
        
        NSLayoutConstraint.activate([
            newChild.leadingAnchor.constraint(equalTo: childContainer.leadingAnchor),
            newChild.trailingAnchor.constraint(equalTo: childContainer.trailingAnchor),
            newChild.topAnchor.constraint(equalTo: childContainer.topAnchor),
            newChild.bottomAnchor.constraint(equalTo: childContainer.bottomAnchor)
        ])
        
        newChild.setNeedsLayout()
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
        let feedbackForm = initialiseStoryboardViewController(EventFeedbackFormViewController.self)
        swapEmbeddedViewController(to: feedbackForm)
    }
    
    func showFeedbackSubmissionInProgress() {
        
    }
    
    func showFeedbackSubmissionSuccessful() {
        
    }
    
    func showFeedbackSubmissionFailedPrompt() {
        
    }
    
    // MARK: Private
    
    private func initialiseStoryboardViewController<T>(_ type: T.Type) -> T where T: UIViewController {
        guard let storyboard = storyboard else {
            fatalError("EventFeedbackViewController must be initialised from a storyboard")
        }
        
        return storyboard.instantiate(type)
    }
    
}
