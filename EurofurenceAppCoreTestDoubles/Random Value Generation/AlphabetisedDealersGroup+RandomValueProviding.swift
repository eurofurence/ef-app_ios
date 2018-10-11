//
//  AlphabetisedDealersGroup+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation
import RandomDataGeneration

extension AlphabetisedDealersGroup: RandomValueProviding {

    public static var random: AlphabetisedDealersGroup {
        return AlphabetisedDealersGroup(indexingString: .random, dealers: .random)
    }

}
