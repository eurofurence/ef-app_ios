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
    func setDelegate(_ delegate: EventDetailViewModelDelegate)
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor)
    func favourite()
    func unfavourite()

}

protocol EventDetailViewModelDelegate {

    func eventFavourited()
    func eventUnfavourited()

}

protocol EventDetailViewModelVisitor {

    func visit(_ summary: EventSummaryViewModel)
    func visit(_ description: EventDescriptionViewModel)
    func visit(_ graphic: EventGraphicViewModel)
    func visit(_ sponsorsOnlyMessage: EventSponsorsOnlyWarningViewModel)
    func visit(_ superSponsorsOnlyMessage: EventSuperSponsorsOnlyWarningViewModel)
    func visit(_ artShowMessage: EventArtShowMessageViewModel)
    func visit(_ kageMessage: EventKageMessageViewModel)
    func visit(_ dealersDenMessage: EventDealersDenMessageViewModel)
    func visit(_ mainStageMessage: EventMainStageMessageViewModel)
    func visit(_ photoshootMessage: EventPhotoshootMessageViewModel)

}

struct EventSummaryViewModel: Equatable, Hashable {

    var title: String
    var subtitle: NSAttributedString
    var eventStartEndTime: String
    var location: String
    var trackName: String
    var eventHosts: String

}

struct EventDescriptionViewModel: Equatable, Hashable {

    var contents: NSAttributedString

}

struct EventGraphicViewModel: Equatable, Hashable {

    var pngGraphicData: Data

}

struct EventSponsorsOnlyWarningViewModel: Equatable, Hashable {

    var message: String

}

struct EventSuperSponsorsOnlyWarningViewModel: Equatable, Hashable {

    var message: String

}

struct EventArtShowMessageViewModel: Equatable, Hashable {

    var message: String

}

struct EventKageMessageViewModel: Equatable, Hashable {

    var message: String

}

struct EventDealersDenMessageViewModel: Equatable, Hashable {

    var message: String

}

struct EventMainStageMessageViewModel: Equatable, Hashable {

    var message: String

}

struct EventPhotoshootMessageViewModel: Equatable, Hashable {

    var message: String

}
