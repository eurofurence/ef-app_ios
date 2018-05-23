//
//  EventDetailViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol EventDetailViewModel {

    var numberOfComponents: Int { get }
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor)

}

protocol EventDetailViewModelVisitor {

    func visit(_ summary: EventSummaryViewModel)
    func visit(_ description: EventDescriptionViewModel)
    func visit(_ graphic: EventGraphicViewModel)

}

struct EventSummaryViewModel: Equatable, Hashable {

    static func ==(lhs: EventSummaryViewModel, rhs: EventSummaryViewModel) -> Bool {
        return lhs.title == rhs.title &&
               lhs.subtitle == rhs.subtitle &&
               lhs.eventStartEndTime == rhs.eventStartEndTime &&
               lhs.location == rhs.location &&
               lhs.trackName == rhs.trackName &&
               lhs.eventHosts == rhs.eventHosts
    }

    var hashValue: Int {
        return title.hashValue ^
               subtitle.hashValue ^
               eventStartEndTime.hashValue ^
               location.hashValue ^
               trackName.hashValue ^
               eventHosts.hashValue
    }

    var title: String
    var subtitle: String
    var eventStartEndTime: String
    var location: String
    var trackName: String
    var eventHosts: String

}

struct EventDescriptionViewModel: Equatable, Hashable {

    static func ==(lhs: EventDescriptionViewModel, rhs: EventDescriptionViewModel) -> Bool {
        return lhs.contents == rhs.contents
    }

    var hashValue: Int {
        return contents.hashValue
    }

    var contents: String

}

struct EventGraphicViewModel: Equatable, Hashable {

    static func ==(lhs: EventGraphicViewModel, rhs: EventGraphicViewModel) -> Bool {
        return lhs.pngGraphicData == rhs.pngGraphicData
    }

    var hashValue: Int {
        return pngGraphicData.hashValue
    }

    var pngGraphicData: Data

}
