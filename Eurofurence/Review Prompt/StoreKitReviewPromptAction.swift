//
//  StoreKitReviewPromptAction.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import StoreKit

struct StoreKitReviewPromptAction: ReviewPromptAction {

    func showReviewPrompt() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }

}
