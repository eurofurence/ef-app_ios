//
//  Dealer2+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

extension Dealer2: RandomValueProviding {
    
    static var random: Dealer2 {
        return Dealer2(identifier: .random,
                       preferredName: .random,
                       alternateName: .random,
                       isAttendingOnThursday: .random,
                       isAttendingOnFriday: .random,
                       isAttendingOnSaturday: .random,
                       isAfterDark: .random)
    }
    
}

extension Dealer2.Identifier: RandomValueProviding {
    
    static var random: Dealer2.Identifier {
        return Dealer2.Identifier(.random)
    }
    
}
