//
//  CapturingScheduleViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import Foundation
import TestUtilities

extension CapturingScheduleViewModel: RandomValueProviding {

    public static var random: CapturingScheduleViewModel {
        return CapturingScheduleViewModel(days: .random, events: .random, currentDay: .random)
    }

}

extension ScheduleEventGroupViewModel: RandomValueProviding {

    public static var random: ScheduleEventGroupViewModel {
        return ScheduleEventGroupViewModel(title: .random, events: [StubScheduleEventViewModel].random)
    }

}

final class StubScheduleEventViewModel: ScheduleEventViewModelProtocol {

    var title: String
    var startTime: String
    var endTime: String
    var location: String
    var bannerGraphicPNGData: Data?
    var isFavourite: Bool
    var isSponsorOnly: Bool
    var isSuperSponsorOnly: Bool
    var isArtShow: Bool
    var isKageEvent: Bool
    var isDealersDenEvent: Bool
    var isMainStageEvent: Bool
    var isPhotoshootEvent: Bool

    init(title: String,
         startTime: String,
         endTime: String,
         location: String,
         bannerGraphicPNGData: Data?,
         isFavourite: Bool,
         isSponsorOnly: Bool,
         isSuperSponsorOnly: Bool,
         isArtShow: Bool,
         isKageEvent: Bool,
         isDealersDenEvent: Bool,
         isMainStageEvent: Bool,
         isPhotoshootEvent: Bool) {
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
        self.bannerGraphicPNGData = bannerGraphicPNGData
        self.isFavourite = isFavourite
        self.isSponsorOnly = isSponsorOnly
        self.isSuperSponsorOnly = isSuperSponsorOnly
        self.isArtShow = isArtShow
        self.isKageEvent = isKageEvent
        self.isDealersDenEvent = isDealersDenEvent
        self.isMainStageEvent = isMainStageEvent
        self.isPhotoshootEvent = isPhotoshootEvent
    }

}

extension StubScheduleEventViewModel: RandomValueProviding {

    static var random: StubScheduleEventViewModel {
        return StubScheduleEventViewModel(title: .random,
                                          startTime: .random,
                                          endTime: .random,
                                          location: .random,
                                          bannerGraphicPNGData: .random,
                                          isFavourite: .random,
                                          isSponsorOnly: .random,
                                          isSuperSponsorOnly: .random,
                                          isArtShow: .random,
                                          isKageEvent: .random,
                                          isDealersDenEvent: .random,
                                          isMainStageEvent: .random,
                                          isPhotoshootEvent: .random)
    }

}

extension ScheduleDayViewModel: RandomValueProviding {

    public static var random: ScheduleDayViewModel {
        return ScheduleDayViewModel(title: .random)
    }

}
