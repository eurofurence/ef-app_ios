//
//  ScheduleEventViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct ScheduleEventViewModel: Equatable {

    var title: String
    var startTime: String
    var endTime: String
    var location: String
    var isFavourite: Bool
    var isSponsorOnly: Bool
    var isSuperSponsorOnly: Bool
    var isArtShow: Bool
    var isKageEvent: Bool
    var isDealersDenEvent: Bool
    var isMainStageEvent: Bool
    var isPhotoshootEvent: Bool

}
