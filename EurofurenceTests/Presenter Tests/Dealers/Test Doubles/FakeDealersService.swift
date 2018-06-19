//
//  FakeDealersService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeDealersService: DealersService {
    
    private(set) var lastCreatedDealersIndex: FakeDealersIndex?
    func makeDealersIndex() -> DealersIndex {
        let index = FakeDealersIndex()
        lastCreatedDealersIndex = index
        return index
    }
    
}
