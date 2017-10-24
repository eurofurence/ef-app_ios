//
//  TabModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

protocol TabModuleFactory {

    func makeTabModule(_ childModules: [UIViewController]) -> UIViewController

}
