//
//  CapturingReviewPromptAction.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
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
