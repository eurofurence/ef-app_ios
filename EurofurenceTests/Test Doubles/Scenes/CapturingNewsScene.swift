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
    
    typealias Component = AnyObject
    
    let stubbedAnnouncementComponent = CapturingNewsAnnouncementComponent()
    func makeAnnouncementComponent(configuringUsing block: (NewsAnnouncementComponent) -> Void) -> StubNewsComponentFactory.Component {
        block(stubbedAnnouncementComponent)
        return stubbedAnnouncementComponent
    }
    
    let stubbedEventComponent = CapturingNewsEventComponent()
    func makeEventComponent(configuringUsing block: (NewsEventComponent) -> Void) -> AnyObject {
        block(stubbedEventComponent)
        return stubbedEventComponent
    }
    
    let stubbedUserWidgetComponent = CapturingUserWidgetComponent()
    func makeUserWidgetComponent(configuringUsing block: (UserWidgetComponent) -> Void) -> AnyObject {
        block(stubbedUserWidgetComponent)
        return stubbedUserWidgetComponent
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

class CapturingNewsEventComponent: NewsEventComponent {
    
    private(set) var capturedStartTime: String?
    func setEventStartTime(_ startTime: String) {
        capturedStartTime = startTime
    }
    
    private(set) var capturedEndTime: String?
    func setEventEndTime(_ endTime: String) {
        capturedEndTime = endTime
    }
    
    private(set) var capturedEventName: String?
    func setEventName(_ eventName: String) {
        capturedEventName = eventName
    }
    
    private(set) var capturedLocation: String?
    func setLocation(_ location: String) {
        capturedLocation = location
    }
    
    private(set) var capturedIcon: UIImage?
    func setIcon(_ icon: UIImage?) {
        capturedIcon = icon
    }
    
}

class CapturingUserWidgetComponent: UserWidgetComponent {
    
    private(set) var capturedPrompt: String?
    func setPrompt(_ prompt: String) {
        capturedPrompt = prompt
    }
    
    private(set) var capturedDetailedPrompt: String?
    func setDetailedPrompt(_ detailedPrompt: String) {
        capturedDetailedPrompt = detailedPrompt
    }
    
    private(set) var didShowHighlightedPrompt = false
    func showHighlightedUserPrompt() {
        didShowHighlightedPrompt = true
    }
    
    private(set) var didHideHighlightedPrompt = false
    func hideHighlightedUserPrompt() {
        didHideHighlightedPrompt = true
    }
    
    private(set) var didShowStandardPrompt = false
    func showStandardUserPrompt() {
        didShowStandardPrompt = true
    }
    
    private(set) var didHideStandardPrompt = false
    func hideStandardUserPrompt() {
        didHideStandardPrompt = true
    }
    
}

// MARK: Test Helpers

extension CapturingNewsScene {
    
    var stubbedAnnouncementComponent: CapturingNewsAnnouncementComponent {
        return componentFactory.stubbedAnnouncementComponent
    }
    
    var stubbedEventComponent: CapturingNewsEventComponent {
        return componentFactory.stubbedEventComponent
    }
    
    var stubbedUserWidgetComponent: CapturingUserWidgetComponent {
        return componentFactory.stubbedUserWidgetComponent
    }
    
    func tapLoginAction() {
        delegate?.newsSceneDidTapLoginAction(self)
    }
    
    func tapShowMessagesAction() {
        delegate?.newsSceneDidTapShowMessagesAction(self)
    }
    
    func bindComponent(at indexPath: IndexPath) -> Any? {
        return capturedBinder?.bindComponent(at: indexPath, using: componentFactory)
    }
    
}
