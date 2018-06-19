//
//  FakeDealersIndex.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeDealersIndex: DealersIndex {
    
    var alphabetisedDealers = [AlphabetisedDealersGroup].random
    
    func setDelegate(_ delegate: DealersIndexDelegate) {
        delegate.alphabetisedDealersDidChange(to: alphabetisedDealers)
    }
    
}
