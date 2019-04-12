@testable import Eurofurence
import Foundation

class CapturingEventFeedbackScene: EventFeedbackScene {
    
    private var delegate: EventFeedbackSceneDelegate?
    func setDelegate(_ delegate: EventFeedbackSceneDelegate) {
        self.delegate = delegate
    }
    
    private(set) var capturedViewModel: EventFeedbackViewModel?
    func bind(_ viewModel: EventFeedbackViewModel) {
        capturedViewModel = viewModel
    }
    
    func simulateSceneDidLoad() {
        delegate?.eventFeedbackSceneDidLoad()
    }
    
}
