import Eurofurence
import Foundation
import UIKit.UIViewController

class CapturingEventFeedbackScene: UIViewController, EventFeedbackScene {
    
    enum FeedbackState {
        case unset
        case inProgress
        case success
        case feedbackForm
    }
    
    enum NavigationControlsState {
        case unset
        case disabled
        case enabled
    }
    
    enum DismissalState {
        case unset
        case dismissalPermitted
        case dismissalDenied
    }
    
    private var delegate: EventFeedbackSceneDelegate?
    func setDelegate(_ delegate: EventFeedbackSceneDelegate) {
        self.delegate = delegate
    }
    
    private(set) var capturedViewModel: EventFeedbackViewModel?
    func bind(_ viewModel: EventFeedbackViewModel) {
        capturedViewModel = viewModel
    }
    
    private(set) var feedbackState: FeedbackState = .unset
    func showFeedbackSubmissionSuccessful() {
        feedbackState = .success
    }
    
    func showFeedbackSubmissionInProgress() {
        feedbackState = .inProgress
    }
    
    func showFeedbackForm() {
        feedbackState = .feedbackForm
    }
    
    private(set) var didShowFailurePrompt = false
    func showFeedbackSubmissionFailedPrompt() {
        didShowFailurePrompt = true
    }
    
    private(set) var navigationControlsState: NavigationControlsState = .unset
    func disableNavigationControls() {
        navigationControlsState = .disabled
    }
    
    func enableNavigationControls() {
        navigationControlsState = .enabled
    }
    
    private(set) var dismissalState: DismissalState = .unset
    func disableDismissal() {
        dismissalState = .dismissalDenied
    }
    
    func enableDismissal() {
        dismissalState = .dismissalPermitted
    }
    
    private(set) var confirmCancellationAlertPresented = false
    private var discardHandler: (() -> Void)?
    func showDiscardFeedbackPrompt(discardHandler: @escaping () -> Void) {
        confirmCancellationAlertPresented = true
        self.discardHandler = discardHandler
    }
    
    func simulateSceneDidLoad() {
        delegate?.eventFeedbackSceneDidLoad()
    }
    
    func simulateFeedbackTextDidChange(_ feedbackText: String) {
        capturedViewModel?.feedbackChanged(feedbackText)
    }
    
    func simulateFeedbackRatioDidChange(_ feedbackRatio: Float) {
        capturedViewModel?.ratingPercentageChanged(feedbackRatio)
    }
    
    func simulateSubmitFeedbackTapped() {
        capturedViewModel?.submitFeedback()
    }
    
    func simulateCancelFeedbackTapped() {
        capturedViewModel?.cancelFeedback()
    }
    
    func simulateUserWantsToDiscardFeedbackInput() {
        discardHandler?()
    }
    
}
