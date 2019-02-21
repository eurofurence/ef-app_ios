//
//  ScheduleEventViewModelAssertion.swift
//  TestUtilities
//
//  Created by Thomas Sherwood on 21/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import TestUtilities

class ScheduleEventViewModelAssertion: Assertion {

    func assertEventViewModel(_ expected: ScheduleEventViewModel, isEqualTo actual: ScheduleEventViewModel) {
        assert(expected.title, isEqualTo: actual.title)
        assert(expected.startTime, isEqualTo: actual.startTime)
        assert(expected.endTime, isEqualTo: actual.endTime)
        assert(expected.location, isEqualTo: actual.location)
        assert(expected.bannerGraphicPNGData, isEqualTo: actual.bannerGraphicPNGData)
        assert(expected.isFavourite, isEqualTo: actual.isFavourite)
        assert(expected.isSponsorOnly, isEqualTo: actual.isSponsorOnly)
        assert(expected.isSuperSponsorOnly, isEqualTo: actual.isSuperSponsorOnly)
        assert(expected.isArtShow, isEqualTo: actual.isArtShow)
        assert(expected.isKageEvent, isEqualTo: actual.isKageEvent)
        assert(expected.isDealersDenEvent, isEqualTo: actual.isDealersDenEvent)
        assert(expected.isMainStageEvent, isEqualTo: actual.isMainStageEvent)
        assert(expected.isPhotoshootEvent, isEqualTo: actual.isPhotoshootEvent)
    }

}
