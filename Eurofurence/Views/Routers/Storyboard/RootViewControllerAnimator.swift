//
//  RootViewControllerAnimator.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

struct RootViewControllerAnimator {

    var window: UIWindow

    func animateTransition(to viewController: UIViewController) {
        UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.window.rootViewController = viewController
        })
    }

}
