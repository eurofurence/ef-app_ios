//
//  CapturingScheduleViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import Foundation
import RandomDataGeneration

extension CapturingScheduleViewModel: RandomValueProviding {
    
    public static var random: CapturingScheduleViewModel {
        return CapturingScheduleViewModel(days: .random, events: .random, currentDay: .random)
    }
    
}

extension ScheduleEventGroupViewModel: RandomValueProviding {
    
    public static var random: ScheduleEventGroupViewModel {
        return ScheduleEventGroupViewModel(title: .random, events: .random)
    }
    
}

extension ScheduleEventViewModel: RandomValueProviding {
    
    public static var random: ScheduleEventViewModel {
        return ScheduleEventViewModel(title: .random,
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
