//
//  CapturingLoginScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 28/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import UIKit.UIViewController

class CapturingLoginScene: UIViewController, LoginScene {
    
    var delegate: LoginSceneDelegate?
    
    private(set) var capturedTitle: String?
    func setLoginTitle(_ title: String) {
        capturedTitle = title
    }
    
    var loginButtonWasDisabled = false
    func disableLoginButton() {
        loginButtonWasDisabled = true
    }
    
    private(set) var loginButtonWasEnabled = false
    func enableLoginButton() {
        loginButtonWasEnabled = true
    }
    
    func tapLoginButton() {
        delegate?.loginSceneDidTapLoginButton()
    }
    
}
