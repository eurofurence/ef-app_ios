//
//  CapturingNavigationController.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UINavigationController

class CapturingNavigationController: UINavigationController {

    private(set) var pushedViewControllers = [UIViewController]()
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewControllers.append(viewController)
        super.pushViewController(viewController, animated: animated)
    }

    private(set) var viewControllerPoppedTo: UIViewController?
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        viewControllerPoppedTo = viewController
        return super.popToViewController(viewController, animated: animated)
    }

}

extension CapturingNavigationController {

    func contains(_ viewController: UIViewController) -> Bool {
        return viewControllers.contains(viewController)
    }

}
