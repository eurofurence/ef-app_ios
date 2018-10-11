//
//  Event+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation
import RandomDataGeneration

extension Event: RandomValueProviding {

    public static var random: Event {
        let startDate = Date.random
        return Event(identifier: .random,
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

    public static var randomStandardEvent: Event {
        var event = Event.random
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

extension Event.Identifier: RandomValueProviding {

    public static var random: Event.Identifier {
        return Event.Identifier(.random)
    }

}
