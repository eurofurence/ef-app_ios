import Foundation

protocol EventFeedbackScene {
    
    func setDelegate(_ delegate: EventFeedbackSceneDelegate)
    func bind(_ viewModel: EventFeedbackViewModel)
    
}
