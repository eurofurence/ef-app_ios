import Foundation

protocol EventFeedbackScene {
    
    func setDelegate(_ delegate: EventFeedbackSceneDelegate)
    func bind(_ viewModel: EventFeedbackViewModel)
    func showFeedbackForm()
    func showFeedbackSubmissionInProgress()
    func hideFeedbackSubmissionProgress()
    func showFeedbackSubmissionSuccessful()
    func showFeedbackSubmissionFailedPrompt()
    
}
