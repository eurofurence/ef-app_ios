//
//  StubDealersModuleFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class StubDealersModuleFactory: DealersModuleProviding {
    
    let stubInterface = UIViewController()
    func makeDealersModule(_ delegate: DealersModuleDelegate) -> UIViewController {
        return stubInterface
    }
    
}
