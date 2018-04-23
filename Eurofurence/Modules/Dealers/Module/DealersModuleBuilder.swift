//
//  DealersModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

class DealersModuleBuilder {

    struct DummyModule: DealersModuleProviding {
        func makeDealersModule() -> UIViewController {
            return UIViewController()
        }
    }

    func build() -> DealersModuleProviding {
        return DummyModule()
    }

}
