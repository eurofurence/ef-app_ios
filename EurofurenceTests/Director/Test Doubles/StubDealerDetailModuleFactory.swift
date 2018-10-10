//
//  StubDealerDetailModuleProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import UIKit

class StubDealerDetailModuleProviding: DealerDetailModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var capturedModel: Dealer2.Identifier?
    func makeDealerDetailModule(for dealer: Dealer2.Identifier) -> UIViewController {
        capturedModel = dealer
        return stubInterface
    }
    
}
