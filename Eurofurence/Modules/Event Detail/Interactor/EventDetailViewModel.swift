//
//  EventDetailViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol EventDetailViewModel {

    func describe(to visitor: EventDetailViewModelVisitor)

}

protocol EventDetailViewModelVisitor {

    func visit(_ summary: EventSummaryViewModel)

}

struct EventSummaryViewModel: Equatable {

    static func ==(lhs: EventSummaryViewModel, rhs: EventSummaryViewModel) -> Bool {
        return lhs.title == rhs.title &&
               lhs.subtitle == rhs.subtitle &&
               lhs.eventStartEndTime == rhs.eventStartEndTime &&
               lhs.location == rhs.location &&
               lhs.trackName == rhs.trackName &&
               lhs.eventHosts == rhs.eventHosts &&
               lhs.eventDescription == rhs.eventDescription
    }

    var title: String
    var subtitle: String
    var eventStartEndTime: String
    var location: String
    var trackName: String
    var eventHosts: String
    var eventDescription: String

}
