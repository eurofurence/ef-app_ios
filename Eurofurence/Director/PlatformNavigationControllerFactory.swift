//
//  PlatformNavigationControllerFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UINavigationController

struct PlatformNavigationControllerFactory: NavigationControllerFactory {

    func makeNavigationController() -> UINavigationController {
        return UINavigationController()
    }

}
