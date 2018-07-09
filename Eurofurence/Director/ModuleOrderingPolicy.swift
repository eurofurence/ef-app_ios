//
//  ModuleOrderingPolicy.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

protocol ModuleOrderingPolicy {

    func order(modules: [UIViewController]) -> [UIViewController]
    func saveOrder(_ modules: [UIViewController])

}
