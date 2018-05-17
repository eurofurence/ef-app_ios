//
//  StubEventDetailModuleFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit

class StubEventDetailModuleFactory: EventDetailModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var capturedModel: Event2?
    func makeEventDetailModule(for event: Event2) -> UIViewController {
        capturedModel = event
        return stubInterface
    }
    
}
