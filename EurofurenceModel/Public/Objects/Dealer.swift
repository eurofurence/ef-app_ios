//
//  Dealer.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public typealias DealerIdentifier = Identifier<DealerProtocol>

public protocol DealerProtocol {

    var identifier: DealerIdentifier { get }

    var preferredName: String { get }
    var alternateName: String? { get }

    var isAttendingOnThursday: Bool { get }
    var isAttendingOnFriday: Bool { get }
    var isAttendingOnSaturday: Bool { get }

    var isAfterDark: Bool { get }

}

struct Dealer: DealerProtocol {

    var identifier: DealerIdentifier

    var preferredName: String
    var alternateName: String?

    var isAttendingOnThursday: Bool
    var isAttendingOnFriday: Bool
    var isAttendingOnSaturday: Bool

    var isAfterDark: Bool

    init(identifier: DealerIdentifier, preferredName: String, alternateName: String?, isAttendingOnThursday: Bool, isAttendingOnFriday: Bool, isAttendingOnSaturday: Bool, isAfterDark: Bool) {
        self.identifier = identifier
        self.preferredName = preferredName
        self.alternateName = alternateName
        self.isAttendingOnThursday = isAttendingOnThursday
        self.isAttendingOnFriday = isAttendingOnFriday
        self.isAttendingOnSaturday = isAttendingOnSaturday
        self.isAfterDark = isAfterDark
    }

}
