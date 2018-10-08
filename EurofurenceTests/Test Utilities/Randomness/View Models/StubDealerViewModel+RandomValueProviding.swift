//
//  DealerViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation
import RandomDataGeneration

extension StubDealerViewModel: RandomValueProviding {
    
    public static var random: StubDealerViewModel {
        return StubDealerViewModel()
    }
    
}
