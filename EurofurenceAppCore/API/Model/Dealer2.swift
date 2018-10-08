//
//  Dealer2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct Dealer2: Equatable {

    public struct Identifier: Equatable, Hashable, RawRepresentable {

        public typealias RawValue = String

        public init(_ value: String) {
            self.rawValue = value
        }

        public init?(rawValue: String) {
            self.rawValue = rawValue
        }

        public var rawValue: String

    }

    public var identifier: Dealer2.Identifier

    public var preferredName: String
    public var alternateName: String?

    public var isAttendingOnThursday: Bool
    public var isAttendingOnFriday: Bool
    public var isAttendingOnSaturday: Bool

    public var isAfterDark: Bool

    public init(identifier: Dealer2.Identifier, preferredName: String, alternateName: String?, isAttendingOnThursday: Bool, isAttendingOnFriday: Bool, isAttendingOnSaturday: Bool, isAfterDark: Bool) {
        self.identifier = identifier
        self.preferredName = preferredName
        self.alternateName = alternateName
        self.isAttendingOnThursday = isAttendingOnThursday
        self.isAttendingOnFriday = isAttendingOnFriday
        self.isAttendingOnSaturday = isAttendingOnSaturday
        self.isAfterDark = isAfterDark
    }

}
