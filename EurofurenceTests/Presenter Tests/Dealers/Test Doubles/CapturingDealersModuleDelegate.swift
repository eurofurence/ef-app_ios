//
//  CapturingDealersModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class CapturingDealersModuleDelegate: DealersModuleDelegate {

    private(set) var capturedSelectedDealerIdentifier: DealerIdentifier?
    func dealersModuleDidSelectDealer(identifier: DealerIdentifier) {
        capturedSelectedDealerIdentifier = identifier
    }

}
