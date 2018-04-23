//
//  CapturingEventsScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class CapturingEventsScene: UIViewController, EventsScene {
    
    private(set) var capturedTitle: String?
    func setEventsTitle(_ title: String) {
        capturedTitle = title
    }
    
}
