//
//  CapturingWindowWireframe.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import UIKit.UIViewController

class CapturingWindowWireframe: WindowWireframe {
    
    private(set) var capturedRootInterface: UIViewController?
    func setRoot(_ viewController: UIViewController) {
        capturedRootInterface = viewController
    }
    
}
