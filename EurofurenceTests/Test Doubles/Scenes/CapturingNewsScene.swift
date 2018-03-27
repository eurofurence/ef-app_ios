//
//  CapturingNewsScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class CapturingNewsScene: UIViewController, NewsScene {
    
    var delegate: NewsSceneDelegate?
    
    private(set) var capturedTitle: String?
    func showNewsTitle(_ title: String) {
        capturedTitle = title
    }
    
    private(set) var wasToldToShowMessagesNavigationAction = false
    func showMessagesNavigationAction() {
        wasToldToShowMessagesNavigationAction = true
    }
    
    private(set) var wasToldToHideMessagesNavigationAction = false
    func hideMessagesNavigationAction() {
        wasToldToHideMessagesNavigationAction = true
    }
    
    private(set) var wasToldToShowLoginNavigationAction = false
    func showLoginNavigationAction() {
        wasToldToShowLoginNavigationAction = true
    }
    
    private(set) var wasToldToHideLoginNavigationAction = false
    func hideLoginNavigationAction() {
        wasToldToHideLoginNavigationAction = true
    }
    
    private(set) var capturedWelcomePrompt: String?
    func showWelcomePrompt(_ prompt: String) {
        capturedWelcomePrompt = prompt
    }
    
    private(set) var capturedWelcomeDescription: String?
    func showWelcomeDescription(_ description: String) {
        capturedWelcomeDescription = description
    }
    
    private(set) var capturedLoginPrompt: String?
    func showLoginPrompt(_ prompt: String) {
        capturedLoginPrompt = prompt
    }
    
    private(set) var capturedLoginDescription: String?
    func showLoginDescription(_ description: String) {
        capturedLoginDescription = description
    }
    
}

// MARK: Test Helpers

extension CapturingNewsScene {
    
    func tapLoginAction() {
        delegate?.newsSceneDidTapLoginAction(self)
    }
    
    func tapShowMessagesAction() {
        delegate?.newsSceneDidTapShowMessagesAction(self)
    }
    
}
