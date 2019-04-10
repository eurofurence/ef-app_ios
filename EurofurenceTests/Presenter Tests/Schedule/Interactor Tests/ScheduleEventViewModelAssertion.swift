//
//  ScheduleEventViewModelAssertion.swift
//  TestUtilities
//
//  Created by Thomas Sherwood on 21/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModelTestDoubles
import TestUtilities

class ScheduleEventViewModelAssertion: Assertion {

    private let context: ScheduleInteractorTestBuilder.Context

    init(context: ScheduleInteractorTestBuilder.Context, file: StaticString = #file, line: UInt = #line) {
        self.context = context
        super.init(file: file, line: line)
    }

    func assertEventViewModel(_ viewModel: ScheduleEventViewModelProtocol,
                              isModeledBy event: FakeEvent) {
        let expectedStartTime = context.hoursFormatter.hoursString(from: event.startDate)
        let expectedEndTime = context.hoursFormatter.hoursString(from: event.endDate)

        assert(viewModel.title, isEqualTo: event.title)
        assert(viewModel.startTime, isEqualTo: expectedStartTime)
        assert(viewModel.endTime, isEqualTo: expectedEndTime)
        assert(viewModel.location, isEqualTo: event.room.name)
        assert(viewModel.bannerGraphicPNGData, isEqualTo: event.bannerGraphicPNGData)
        assert(viewModel.isFavourite, isEqualTo: event.favouritedState == .favourited)
        assert(viewModel.isSponsorOnly, isEqualTo: event.isSponsorOnly)
        assert(viewModel.isSuperSponsorOnly, isEqualTo: event.isSuperSponsorOnly)
        assert(viewModel.isArtShow, isEqualTo: event.isArtShow)
        assert(viewModel.isKageEvent, isEqualTo: event.isKageEvent)
        assert(viewModel.isDealersDenEvent, isEqualTo: event.isDealersDen)
        assert(viewModel.isMainStageEvent, isEqualTo: event.isMainStage)
        assert(viewModel.isPhotoshootEvent, isEqualTo: event.isPhotoshoot)
    }

}
