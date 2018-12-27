//
//  StubEventDetailModuleFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceAppCoreTestDoubles
import UIKit

class StubEventDetailModuleFactory: EventDetailModuleProviding {

    let stubInterface = UIViewController()
    private(set) var capturedModel: Event.Identifier?
    func makeEventDetailModule(for event: Event.Identifier) -> UIViewController {
        capturedModel = event
        return stubInterface
    }

}
