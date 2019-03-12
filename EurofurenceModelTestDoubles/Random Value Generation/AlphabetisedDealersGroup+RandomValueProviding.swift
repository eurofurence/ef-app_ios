//
//  AlphabetisedDealersGroup+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import TestUtilities

extension AlphabetisedDealersGroup: RandomValueProviding {

    public static var random: AlphabetisedDealersGroup {
        return AlphabetisedDealersGroup(indexingString: .random, dealers: [FakeDealer].random)
    }

}
