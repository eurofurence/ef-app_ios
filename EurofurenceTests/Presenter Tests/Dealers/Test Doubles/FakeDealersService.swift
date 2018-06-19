//
//  FakeDealersService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct FakeDealersService: DealersService {
    
    var dealers: [Dealer2]
    
    func add(_ dealersServiceObserver: DealersServiceObserver) {
        dealersServiceObserver.dealersDidChange(dealers)
    }
    
}
