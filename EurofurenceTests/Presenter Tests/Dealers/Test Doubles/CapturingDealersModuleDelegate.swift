//
//  CapturingDealersModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingDealersModuleDelegate: DealersModuleDelegate {
    
    private(set) var capturedSelectedDealerIdentifier: Dealer2.Identifier?
    func dealersModuleDidSelectDealer(identifier: Dealer2.Identifier) {
        capturedSelectedDealerIdentifier = identifier
    }
    
}
