//
//  StubDealer.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 15/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import TestUtilities

public struct StubDealer: Dealer {

    public var identifier: DealerIdentifier
    public var preferredName: String
    public var alternateName: String?
    public var isAttendingOnThursday: Bool
    public var isAttendingOnFriday: Bool
    public var isAttendingOnSaturday: Bool
    public var isAfterDark: Bool

}

extension StubDealer: RandomValueProviding {

    public static var random: StubDealer {
        return StubDealer(identifier: .random,
                          preferredName: .random,
                          alternateName: .random,
                          isAttendingOnThursday: .random,
                          isAttendingOnFriday: .random,
                          isAttendingOnSaturday: .random,
                          isAfterDark: .random)
    }

}
