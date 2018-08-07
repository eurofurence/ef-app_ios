//
//  Event2+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

extension Event2: RandomValueProviding {
    
    static var random: Event2 {
        let startDate = Date.random
        return Event2(identifier: .random,
                      title: .random,
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
                      isArtShow: .random)
    }
    
    static var randomStandardEvent: Event2 {
        var event = Event2.random
        event.isSponsorOnly = false
        event.isSuperSponsorOnly = false
        
        return event
    }
    
}

extension Event2.Identifier: RandomValueProviding {
    
    static var random: Event2.Identifier {
        return Event2.Identifier(.random)
    }
    
}
