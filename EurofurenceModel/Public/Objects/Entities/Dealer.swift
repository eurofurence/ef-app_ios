//
//  Dealer.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public typealias DealerIdentifier = Identifier<Dealer>

public protocol Dealer {

    var identifier: DealerIdentifier { get }

    var preferredName: String { get }
    var alternateName: String? { get }

    var isAttendingOnThursday: Bool { get }
    var isAttendingOnFriday: Bool { get }
    var isAttendingOnSaturday: Bool { get }

    var isAfterDark: Bool { get }
    
    func fetchExtendedDealerData(completionHandler: @escaping (ExtendedDealerData) -> Void)
    func fetchIconPNGData(completionHandler: @escaping (Data?) -> Void)

}
