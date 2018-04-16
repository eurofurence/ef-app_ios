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
    
    private(set) var capturedComponentsToBind: Int?
    private(set) var capturedNumberOfItemsPerComponentToBind: [Int] = []
    private(set) var capturedBinder: NewsComponentsBinder?
    let componentFactory = StubNewsComponentFactory()
    func bind(numberOfItemsPerComponent: [Int], using binder: NewsComponentsBinder) {
        capturedComponentsToBind = numberOfItemsPerComponent.count
        capturedNumberOfItemsPerComponentToBind = numberOfItemsPerComponent
        capturedBinder = binder
    }
    
}

class StubNewsComponentFactory: NewsComponentFactory {
    
    let stubbedAnnouncementComponent = CapturingNewsAnnouncementComponent()
    func makeAnnouncementComponent() -> NewsAnnouncementComponent {
        return stubbedAnnouncementComponent
    }
    
}

class CapturingNewsAnnouncementComponent: NewsAnnouncementComponent {
    
    private(set) var capturedTitle: String?
    func setAnnouncementTitle(_ title: String) {
        capturedTitle = title
    }
    
    private(set) var capturedDetail: String?
    func setAnnouncementDetail(_ detail: String) {
        capturedDetail = detail
    }
    
}

// MARK: Test Helpers

extension CapturingNewsScene {
    
    var stubbedAnnouncementComponent: CapturingNewsAnnouncementComponent {
        return componentFactory.stubbedAnnouncementComponent
    }
    
    func tapLoginAction() {
        delegate?.newsSceneDidTapLoginAction(self)
    }
    
    func tapShowMessagesAction() {
        delegate?.newsSceneDidTapShowMessagesAction(self)
    }
    
    func bindComponent(at indexPath: IndexPath) {
        capturedBinder?.bindComponent(at: indexPath, using: componentFactory)
    }
    
}
