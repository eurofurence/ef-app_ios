//
//  PhoneWindowWireframeTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class PhoneWindowWireframeTests: XCTestCase {
    
    func testSettingTheRootViewControllerSetsItAsTheRootControllerOnTheWindow() {
        let window = UIWindow()
        let wireframe = PhoneWindowWireframe(window: window)
        let vc = UIViewController()
        wireframe.setRoot(vc)
        
        XCTAssertEqual(vc, window.rootViewController)
    }
    
}
