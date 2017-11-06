//
//  PhoneTabModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UITabBarController
import UIKit.UIViewController

struct PhoneTabModuleFactory: TabModuleFactory {

    func makeTabModule(_ childModules: [UIViewController]) -> UIViewController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = childModules

        return tabBarController
    }

}
