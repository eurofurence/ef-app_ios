//
//  StubDealerDetailModuleProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit

class StubDealerDetailModuleProviding: DealerDetailModuleProviding {

    let stubInterface = UIViewController()
    private(set) var capturedModel: DealerIdentifier?
    func makeDealerDetailModule(for dealer: DealerIdentifier) -> UIViewController {
        capturedModel = dealer
        return stubInterface
    }

}
