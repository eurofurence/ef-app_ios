//
//  DealersModuleProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

protocol DealersModuleProviding {

    func makeDealersModule(_ delegate: DealersModuleDelegate) -> UIViewController

}
