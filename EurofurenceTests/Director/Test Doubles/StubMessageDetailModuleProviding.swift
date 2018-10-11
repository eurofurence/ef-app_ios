//
//  StubMessageDetailModuleProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import UIKit.UIViewController

class StubMessageDetailModuleProviding: MessageDetailModuleProviding {

    let stubInterface = UIViewController()
    private(set) var capturedMessage: Message?
    func makeMessageDetailModule(message: Message) -> UIViewController {
        capturedMessage = message
        return stubInterface
    }

}
