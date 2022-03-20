import UIKit

public class EventFeedbackViewController: UIViewController, EventFeedbackScene {
    
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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        delegate?.eventFeedbackSceneDidLoad()
    }
    
    override public func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        parent?.presentationController?.delegate = self
    }
    
    private func swapEmbeddedViewController(to newChild: UIViewController) {
        newChild.willMove(toParent: self)
        embedChildView(newChild.view)
        newChild.didMove(toParent: self)
        
        if let existingChild = embeddedChild {
            performContainerTransition(from: existingChild.view, to: newChild.view, completion: {
                self.unembedExistingChildController()
                self.embeddedChild = newChild
            })
        } else {
            unembedExistingChildController()
            embeddedChild = newChild
        }
    }
    
    private func performContainerTransition(from original: UIView, to new: UIView, completion: @escaping () -> Void) {
        new.alpha = 0
        
        let animations: () -> Void = {
            new.alpha = 1
            original.alpha = 0
        }
        
        UIView.animate(withDuration: 0.25, animations: animations, completion: { (_) in completion() })
    }
    
    private func unembedExistingChildController() {
        if let embeddedChild = embeddedChild {
            embeddedChild.willMove(toParent: nil)
            embeddedChild.view.removeFromSuperview()
            embeddedChild.removeFromParent()
            embeddedChild.didMove(toParent: nil)
        }
    }
    
    private func embedChildView(_ newChild: UIView) {
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
    public func setDelegate(_ delegate: EventFeedbackSceneDelegate) {
        self.delegate = delegate
    }
    
    private var viewModel: EventFeedbackViewModel?
    public func bind(_ viewModel: EventFeedbackViewModel) {
        self.viewModel = viewModel
        
        eventTitleLabel.text = viewModel.eventTitle
        eventSubtitleLabel.text = [
            viewModel.eventDayAndTime,
            viewModel.eventLocation,
            viewModel.eventHosts
        ].joined(separator: "\n")
    }
    
    public func showFeedbackForm() {
        let feedbackForm = initialiseStoryboardViewController(EventFeedbackFormViewController.self)
        feedbackForm.viewModel = viewModel
        swapEmbeddedViewController(to: feedbackForm)
    }
    
    public func showFeedbackSubmissionInProgress() {
        let feedbackProgress = initialiseStoryboardViewController(EventFeedbackProgressViewController.self)
        swapEmbeddedViewController(to: feedbackProgress)
    }
    
    public func showFeedbackSubmissionSuccessful() {
        let successViewController = initialiseStoryboardViewController(EventFeedbackSuccessViewController.self)
        swapEmbeddedViewController(to: successViewController)
    }
    
    public func showFeedbackSubmissionFailedPrompt() {
        let feedbackErrorTitle = NSLocalizedString(
            "FeedbackErrorTitle",
            bundle: .module,
            comment: "Title for the alert displayed when attempting to leave feedback for an event fails"
        )
        
        let feedbackErrorMessage = NSLocalizedString(
            "FeedbackErrorMessage",
            bundle: .module,
            comment: "Message for the alert displayed when attempting to leave feedback for an event fails"
        )
        
        let alert = UIAlertController(title: feedbackErrorTitle, message: feedbackErrorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .ok, style: .cancel))
        present(alert, animated: true)
    }
    
    public func disableNavigationControls() {
        barButtonItems.forEach({ $0.isEnabled = false })
    }
    
    public func enableNavigationControls() {
        barButtonItems.forEach({ $0.isEnabled = true })
    }
    
    public func disableDismissal() {
        isModalInPresentation = true
    }
    
    public func enableDismissal() {
        isModalInPresentation = false
    }
    
    public func showDiscardFeedbackPrompt(discardHandler: @escaping () -> Void) {
        let confirmDiscardEventFeedbackTitle = NSLocalizedString(
            "ConfirmDiscardEventFeedbackTitle",
            bundle: .module,
            comment: "Title for the alert when confirming event feedback will be discarded"
        )
        
        let alert = UIAlertController(title: confirmDiscardEventFeedbackTitle, message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: .cancel, style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(UIAlertAction(title: .discard, style: .destructive, handler: { (_) in discardHandler() }))
        alert.preferredAction = cancelAction
        
        present(alert, animated: true)
    }
    
    // MARK: Private
    
    private func initialiseStoryboardViewController<T>(_ type: T.Type) -> T where T: UIViewController {
        guard let storyboard = storyboard else {
            fatalError("EventFeedbackViewController must be initialised from a storyboard")
        }
        
        return storyboard.instantiate(type)
    }
    
    private var barButtonItems: [UIBarButtonItem] {
        let leftBarButtonItems = navigationItem.leftBarButtonItems ?? []
        let rightBarButtonItems = navigationItem.rightBarButtonItems ?? []
        
        return leftBarButtonItems + rightBarButtonItems
    }
    
}

// MARK: - UIAdaptivePresentationControllerDelegate

extension EventFeedbackViewController: UIAdaptivePresentationControllerDelegate {
    
    public func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        viewModel?.cancelFeedback()
    }
    
}
