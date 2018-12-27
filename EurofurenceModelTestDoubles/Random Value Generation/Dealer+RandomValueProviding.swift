//
//  Dealer+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import RandomDataGeneration

extension Dealer: RandomValueProviding {

    public static var random: Dealer {
        return Dealer(identifier: .random,
                       preferredName: .random,
                       alternateName: .random,
                       isAttendingOnThursday: .random,
                       isAttendingOnFriday: .random,
                       isAttendingOnSaturday: .random,
                       isAfterDark: .random)
    }

}

extension Dealer.Identifier: RandomValueProviding {

    public static var random: Dealer.Identifier {
        return Dealer.Identifier(.random)
    }

}
