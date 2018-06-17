//
//  StubEventsModuleProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class StubEventsModuleFactory: ScheduleModuleProviding {

    let stubInterface = UIViewController()
    func makeScheduleModule(_ delegate: ScheduleModuleDelegate) -> UIViewController {
        return stubInterface
    }
    
}
