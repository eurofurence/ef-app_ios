//
//  StubEventDetailModuleFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit

class StubEventDetailModuleFactory: EventDetailModuleProviding {

    let stubInterface = UIViewController()
    private(set) var capturedModel: EventIdentifier?
    func makeEventDetailModule(for event: EventIdentifier) -> UIViewController {
        capturedModel = event
        return stubInterface
    }

}
