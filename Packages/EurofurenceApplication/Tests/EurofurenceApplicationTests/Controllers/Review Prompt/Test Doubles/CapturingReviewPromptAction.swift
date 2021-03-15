import EurofurenceApplication
import EurofurenceModel
import Foundation

class CapturingReviewPromptAction: ReviewPromptAction {

    private(set) var didShowReviewPrompt = false
    func showReviewPrompt() {
        didShowReviewPrompt = true
    }

    func reset() {
        didShowReviewPrompt = false
    }

}
