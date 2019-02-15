//
//  Dealer.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public typealias DealerIdentifier = Identifier<Dealer>

public protocol DealerProtocol {

    var identifier: DealerIdentifier { get }

    var preferredName: String { get }
    var alternateName: String? { get }

    var isAttendingOnThursday: Bool { get }
    var isAttendingOnFriday: Bool { get }
    var isAttendingOnSaturday: Bool { get }

    var isAfterDark: Bool { get }

}

public struct Dealer: DealerProtocol {

    public var identifier: DealerIdentifier

    public var preferredName: String
    public var alternateName: String?

    public var isAttendingOnThursday: Bool
    public var isAttendingOnFriday: Bool
    public var isAttendingOnSaturday: Bool

    public var isAfterDark: Bool

    public init(identifier: DealerIdentifier, preferredName: String, alternateName: String?, isAttendingOnThursday: Bool, isAttendingOnFriday: Bool, isAttendingOnSaturday: Bool, isAfterDark: Bool) {
        self.identifier = identifier
        self.preferredName = preferredName
        self.alternateName = alternateName
        self.isAttendingOnThursday = isAttendingOnThursday
        self.isAttendingOnFriday = isAttendingOnFriday
        self.isAttendingOnSaturday = isAttendingOnSaturday
        self.isAfterDark = isAfterDark
    }

}
