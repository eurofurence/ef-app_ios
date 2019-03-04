//
//  DealerImpl.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 15/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

struct DealerImpl: Dealer {

    var identifier: DealerIdentifier

    var preferredName: String
    var alternateName: String?

    var isAttendingOnThursday: Bool
    var isAttendingOnFriday: Bool
    var isAttendingOnSaturday: Bool

    var isAfterDark: Bool

    init(identifier: DealerIdentifier,
         preferredName: String,
         alternateName: String?,
         isAttendingOnThursday: Bool,
         isAttendingOnFriday: Bool,
         isAttendingOnSaturday: Bool,
         isAfterDark: Bool) {
        self.identifier = identifier
        self.preferredName = preferredName
        self.alternateName = alternateName
        self.isAttendingOnThursday = isAttendingOnThursday
        self.isAttendingOnFriday = isAttendingOnFriday
        self.isAttendingOnSaturday = isAttendingOnSaturday
        self.isAfterDark = isAfterDark
    }

}
