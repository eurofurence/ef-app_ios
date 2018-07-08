//
//  PhoneTabModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UITabBarController
import UIKit.UIViewController

struct PhoneTabModuleFactory: TabModuleProviding {

    func makeTabModule(_ childModules: [UIViewController]) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = childModules

        return tabBarController
    }

}
