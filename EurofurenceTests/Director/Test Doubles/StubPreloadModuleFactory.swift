//
//  StubPreloadModuleFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class StubPreloadModuleFactory: PreloadModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var delegate: PreloadModuleDelegate?
    func makePreloadModule(_ delegate: PreloadModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}
