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

class CapturingEventDetailScene: UIViewController, EventDetailScene {
    
    fileprivate var delegate: EventDetailSceneDelegate?
    func setDelegate(_ delegate: EventDetailSceneDelegate) {
        self.delegate = delegate
    }
    
    private(set) var capturedTitle: String?
    func setEventTitle(_ title: String) {
        capturedTitle = title
    }
    
}

extension CapturingEventDetailScene {
    
    func simulateSceneDidLoad() {
        delegate?.eventDetailSceneDidLoad()
    }
    
}
