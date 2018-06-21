//
//  FakeDealerDetailViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeDealerDetailViewModel: DealerDetailViewModel {
    
    init(numberOfComponents: Int) {
        self.numberOfComponents = numberOfComponents
    }
    
    var numberOfComponents: Int
    
}
