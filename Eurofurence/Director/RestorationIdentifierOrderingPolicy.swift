//
//  RestorationIdentifierOrderingPolicy.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class RestorationIdentifierOrderingPolicy: ModuleOrderingPolicy {

    func order(modules: [UIViewController]) -> [UIViewController] {
        return modules
    }

    func saveOrder(_ modules: [UIViewController]) {

    }

}
