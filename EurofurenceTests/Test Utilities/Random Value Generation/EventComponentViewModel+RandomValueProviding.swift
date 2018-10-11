//
//  EventComponentViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import RandomDataGeneration

extension EventComponentViewModel: RandomValueProviding {

    public static var random: EventComponentViewModel {
        return EventComponentViewModel(startTime: .random,
                                       endTime: .random,
                                       eventName: .random,
                                       location: .random,
                                       isSponsorEvent: .random,
                                       isSuperSponsorEvent: .random,
                                       isFavourite: .random,
                                       isArtShowEvent: .random,
                                       isKageEvent: .random,
                                       isDealersDenEvent: .random,
                                       isMainStageEvent: .random,
                                       isPhotoshootEvent: .random)
    }

}
