//
//  StubDealersModuleFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import UIKit.UIViewController

class StubDealersModuleFactory: DealersModuleProviding {

    let stubInterface = FakeViewController()
    fileprivate var delegate: DealersModuleDelegate?
    func makeDealersModule(_ delegate: DealersModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }

}

extension StubDealersModuleFactory {

    func simulateDidSelectDealer(_ dealer: Dealer.Identifier) {
        delegate?.dealersModuleDidSelectDealer(identifier: dealer)
    }

}
