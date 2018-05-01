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
    
    let stubbedCountdownComponent = CapturingConventionCountdownComponent()
    func makeConventionCountdownComponent(configuringUsing block: (ConventionCountdownComponent) -> Void) -> StubNewsComponentFactory.Component {
        block(stubbedCountdownComponent)
        return stubbedCountdownComponent
    }
    
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

class CapturingConventionCountdownComponent: ConventionCountdownComponent {
    
    private(set) var capturedTimeUntilConvention: String?
    func setTimeUntilConvention(_ timeUntilConvention: String) {
        capturedTimeUntilConvention = timeUntilConvention
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
    
    var stubbedCountdownComponent: CapturingConventionCountdownComponent {
        return componentFactory.stubbedCountdownComponent
    }
    
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
    
    func simulateSelectingComponent(at indexPath: IndexPath) {
        delegate?.newsSceneDidSelectComponent(at: indexPath)
    }
    
}
