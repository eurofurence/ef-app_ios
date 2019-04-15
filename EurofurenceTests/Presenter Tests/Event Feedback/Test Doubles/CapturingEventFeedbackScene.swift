@testable import Eurofurence
import Foundation

class CapturingEventFeedbackScene: EventFeedbackScene {
    
    enum State {
        case unset
        case success
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
