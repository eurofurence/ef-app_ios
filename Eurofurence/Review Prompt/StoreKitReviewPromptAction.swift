import StoreKit

struct StoreKitReviewPromptAction: ReviewPromptAction {

    func showReviewPrompt() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }

}
