import Foundation

public protocol EventFeedbackScene {
    
    func setDelegate(_ delegate: EventFeedbackSceneDelegate)
    func bind(_ viewModel: EventFeedbackViewModel)
    func showFeedbackForm()
    func showFeedbackSubmissionInProgress()
    func showFeedbackSubmissionSuccessful()
    func showFeedbackSubmissionFailedPrompt()
    func disableNavigationControls()
    func enableNavigationControls()
    func showDiscardFeedbackPrompt(discardHandler: @escaping () -> Void)
    
}
