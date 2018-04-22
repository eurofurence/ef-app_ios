//
//  StubLoginModuleFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class StubLoginModuleFactory: LoginModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var delegate: LoginModuleDelegate?
    func makeLoginModule(_ delegate: LoginModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

extension StubLoginModuleFactory {
    
    func simulateLoginCancelled() {
        delegate?.loginModuleDidCancelLogin()
    }
    
    func simulateLoginSucceeded() {
        delegate?.loginModuleDidLoginSuccessfully()
    }
    
}
