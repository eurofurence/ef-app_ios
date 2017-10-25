//
//  NavigationControllerFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UINavigationController

protocol NavigationControllerFactory {

    func makeNavigationController() -> UINavigationController

}
