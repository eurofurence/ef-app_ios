//
//  Event2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct Event2: Equatable {

    static func ==(lhs: Event2, rhs: Event2) -> Bool {
        return lhs.title == rhs.title &&
               lhs.abstract == rhs.abstract &&
               lhs.room == rhs.room &&
               lhs.track == rhs.track &&
               lhs.hosts == rhs.hosts &&
               lhs.startDate == rhs.startDate &&
               lhs.endDate == rhs.endDate &&
               lhs.eventDescription == rhs.eventDescription &&
               lhs.posterGraphicPNGData == rhs.posterGraphicPNGData &&
               lhs.bannerGraphicPNGData == rhs.bannerGraphicPNGData
    }

    var title: String
    var abstract: String
    var room: Room
    var track: Track
    var hosts: String
    var startDate: Date
    var endDate: Date
    var eventDescription: String
    var posterGraphicPNGData: Data?
    var bannerGraphicPNGData: Data?

}
