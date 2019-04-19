@testable import Eurofurence
import Foundation
import UIKit.UIViewController

class CapturingEventFeedbackScene: UIViewController, EventFeedbackScene {
    
    enum State {
        case unset
        case inProgress
        case hiddenProgress
        case success
        case feedbackForm
    }
    
    private var delegate: EventFeedbackSceneDelegate?
    func setDelegate(_ delegate: EventFeedbackSceneDelegate) {
        self.delegate = delegate
    }
    
    private(set) var capturedViewModel: EventFeedbackViewModel?
    func bind(_ viewModel: EventFeedbackViewModel) {
        capturedViewModel = viewModel
    }
    
    private(set) var feedbackState: State = .unset
    func showFeedbackSubmissionSuccessful() {
        feedbackState = .success
    }
    
    func showFeedbackSubmissionInProgress() {
        feedbackState = .inProgress
    }
    
    func hideFeedbackSubmissionProgress() {
        feedbackState = .hiddenProgress
    }
    
    func showFeedbackForm() {
        feedbackState = .feedbackForm
    }
    
    private(set) var didShowFailurePrompt = false
    func showFeedbackSubmissionFailedPrompt() {
        didShowFailurePrompt = true
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
    
}
