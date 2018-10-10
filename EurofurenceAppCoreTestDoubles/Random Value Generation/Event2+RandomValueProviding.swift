//
//  Event2+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation
import RandomDataGeneration

extension Event2: RandomValueProviding {
    
    public static var random: Event2 {
        let startDate = Date.random
        return Event2(identifier: .random,
                      title: .random,
                      subtitle: .random,
                      abstract: .random,
                      room: .random,
                      track: .random,
                      hosts: .random,
                      startDate: startDate,
                      endDate: startDate.addingTimeInterval(.random),
                      eventDescription: .random,
                      posterGraphicPNGData: .random,
                      bannerGraphicPNGData: .random,
                      isSponsorOnly: .random,
                      isSuperSponsorOnly: .random,
                      isArtShow: .random,
                      isKageEvent: .random,
                      isDealersDen: .random,
                      isMainStage: .random,
                      isPhotoshoot: .random)
    }
    
    public static var randomStandardEvent: Event2 {
        var event = Event2.random
        event.isSponsorOnly = false
        event.isSuperSponsorOnly = false
        event.isArtShow = false
        event.isKageEvent = false
        event.isMainStage = false
        event.isPhotoshoot = false
        event.isDealersDen = false
        
        return event
    }
    
}

extension Event2.Identifier: RandomValueProviding {
    
    public static var random: Event2.Identifier {
        return Event2.Identifier(.random)
    }
    
}
