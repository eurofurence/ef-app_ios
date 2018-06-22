//
//  ExtendedDealerData.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct ExtendedDealerData {

    var artistImagePNGData: Data?
    var preferredName: String
    var alternateName: String?
    var categories: [String]
    var dealerShortDescription: String
    var isAttendingOnThursday: Bool
    var isAttendingOnFriday: Bool
    var isAttendingOnSaturday: Bool
    var isAfterDark: Bool
    var websiteName: String?
    var twitterUsername: String?
    var telegramUsername: String?

}
