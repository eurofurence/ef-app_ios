//
//  StubDealer.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 15/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import TestUtilities

public final class StubDealer: Dealer {

    public var identifier: DealerIdentifier
    public var preferredName: String
    public var alternateName: String?
    public var isAttendingOnThursday: Bool
    public var isAttendingOnFriday: Bool
    public var isAttendingOnSaturday: Bool
    public var isAfterDark: Bool
    
    public var extendedData: ExtendedDealerData?
    public var iconPNGData: Data?

    public init(identifier: DealerIdentifier,
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
    
    public func fetchExtendedDealerData(completionHandler: @escaping (ExtendedDealerData) -> Void) {
        extendedData.let(completionHandler)
    }
    
    public func fetchIconPNGData(completionHandler: @escaping (Data?) -> Void) {
        completionHandler(iconPNGData)
    }

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
