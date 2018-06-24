//
//  CapturingCollectThemAllScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit

class CapturingCollectThemAllScene: UIViewController, CollectThemAllScene {
    
    private(set) var capturedShortTitle: String?
    func setShortCollectThemAllTitle(_ shortTitle: String) {
        capturedShortTitle = shortTitle
    }
    
    private(set) var capturedTitle: String?
    func setCollectThemAllTitle(_ title: String) {
        capturedTitle = title
    }
    
}
