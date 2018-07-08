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
    
    let stubInterface = FakeTabBarController()
    private(set) var capturedTabModules: [UIViewController] = []
    func makeTabModule(_ childModules: [UIViewController]) -> UITabBarController {
        capturedTabModules = childModules
        stubInterface.viewControllers = childModules
        return stubInterface
    }
    
    func navigationController(for viewController: UIViewController) -> CapturingNavigationController? {
        return capturedTabModules
            .compactMap({ $0 as? CapturingNavigationController })
            .first(where: { $0.contains(viewController) })
    }
    
}

class FakeTabBarController: UITabBarController {
    
    private(set) var capturedPresentedViewController: UIViewController?
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        capturedPresentedViewController = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    private(set) var didDismissViewController = false
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        didDismissViewController = true
        super.dismiss(animated: flag, completion: completion)
    }
    
    private(set) var selectedTabIndex: Int = -1
    override var selectedIndex: Int {
        didSet {
            selectedTabIndex = selectedIndex
        }
    }
    
}
