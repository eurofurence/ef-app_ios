//
//  CapturingEventDetailScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation
import UIKit.UIViewController

class CapturingEventSummaryComponent: EventSummaryComponent {
    
    private(set) var capturedTitle: String?
    func setEventTitle(_ title: String) {
        capturedTitle = title
    }
    
    private(set) var capturedEventStartTime: String?
    func setEventStartTime(_ startTime: String) {
        capturedEventStartTime = startTime
    }
    
    private(set) var capturedEventLocation: String?
    func setEventLocation(_ location: String) {
        capturedEventLocation = location
    }
    
}

class StubEventDetailComponentFactory: EventDetailComponentFactory {
    
    let stubbedEventSummaryComponent = CapturingEventSummaryComponent()
    func makeEventSummaryComponent(configuringUsing block: (EventSummaryComponent) -> Void) {
        block(stubbedEventSummaryComponent)
    }
    
}

class CapturingEventDetailScene: UIViewController, EventDetailScene {
    
    fileprivate var delegate: EventDetailSceneDelegate?
    func setDelegate(_ delegate: EventDetailSceneDelegate) {
        self.delegate = delegate
    }
    
    fileprivate let componentFactory = StubEventDetailComponentFactory()
    fileprivate var binder: EventDetailBinder?
    func bind(using binder: EventDetailBinder) {
        self.binder = binder
    }
    
}

extension CapturingEventDetailScene {
    
    var stubbedEventSummaryComponent: CapturingEventSummaryComponent {
        return componentFactory.stubbedEventSummaryComponent
    }
    
    func simulateSceneDidLoad() {
        delegate?.eventDetailSceneDidLoad()
    }
    
    func bindComponent(at indexPath: IndexPath) {
        binder?.bindComponent(at: indexPath, using: componentFactory)
    }
    
}
