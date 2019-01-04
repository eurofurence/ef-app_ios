//
//  StubMessageDetailModuleProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class StubMessageDetailModuleProviding: MessageDetailModuleProviding {

    let stubInterface = UIViewController()
    private(set) var capturedMessage: APIMessage?
    func makeMessageDetailModule(message: APIMessage) -> UIViewController {
        capturedMessage = message
        return stubInterface
    }

}
