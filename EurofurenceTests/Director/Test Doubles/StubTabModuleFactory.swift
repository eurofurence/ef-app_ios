//
//  StubTabModuleFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class StubTabModuleFactory: TabModuleProviding {
    
    let stubInterface = FakeViewController()
    private(set) var capturedTabModules: [UIViewController] = []
    func makeTabModule(_ childModules: [UIViewController]) -> UIViewController {
        capturedTabModules = childModules
        return stubInterface
    }
    
    func navigationController(for viewController: UIViewController) -> CapturingNavigationController? {
        return capturedTabModules
            .flatMap({ $0 as? CapturingNavigationController })
            .first(where: { $0.topViewController === viewController })
    }
    
}
