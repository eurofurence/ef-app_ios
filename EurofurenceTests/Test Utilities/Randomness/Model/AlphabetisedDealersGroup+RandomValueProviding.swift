//
//  AlphabetisedDealersGroup+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

extension AlphabetisedDealersGroup: RandomValueProviding {
    
    static var random: AlphabetisedDealersGroup {
        return AlphabetisedDealersGroup(indexingString: .random, dealers: .random)
    }
    
}
