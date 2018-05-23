//
//  EventSummaryViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

extension EventSummaryViewModel: RandomValueProviding {
    
    static var random: EventSummaryViewModel {
        return EventSummaryViewModel(title: .random,
                                     subtitle: .random,
                                     eventStartEndTime: .random,
                                     location: .random,
                                     trackName: .random,
                                     eventHosts: .random)
    }
    
}
