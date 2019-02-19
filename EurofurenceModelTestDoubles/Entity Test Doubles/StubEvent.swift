//
//  Event+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import RandomDataGeneration

public final class StubEvent: Event {

    public enum FavouritedState {
        case unset
        case favourited
    }

    public var identifier: EventIdentifier
    public var title: String
    public var subtitle: String
    public var abstract: String
    public var room: Room
    public var track: Track
    public var hosts: String
    public var startDate: Date
    public var endDate: Date
    public var eventDescription: String
    public var posterGraphicPNGData: Data?
    public var bannerGraphicPNGData: Data?
    public var isSponsorOnly: Bool
    public var isSuperSponsorOnly: Bool
    public var isArtShow: Bool
    public var isKageEvent: Bool
    public var isDealersDen: Bool
    public var isMainStage: Bool
    public var isPhotoshoot: Bool

    public init(identifier: EventIdentifier,
                title: String,
                subtitle: String,
                abstract: String,
                room: Room,
                track: Track,
                hosts: String,
                startDate: Date,
                endDate: Date,
                eventDescription: String,
                posterGraphicPNGData: Data?,
                bannerGraphicPNGData: Data?,
                isSponsorOnly: Bool,
                isSuperSponsorOnly: Bool,
                isArtShow: Bool,
                isKageEvent: Bool,
                isDealersDen: Bool,
                isMainStage: Bool,
                isPhotoshoot: Bool) {
        self.identifier = identifier
        self.title = title
        self.subtitle = subtitle
        self.abstract = abstract
        self.room = room
        self.track = track
        self.hosts = hosts
        self.startDate = startDate
        self.endDate = endDate
        self.eventDescription = eventDescription
        self.posterGraphicPNGData = posterGraphicPNGData
        self.bannerGraphicPNGData = bannerGraphicPNGData
        self.isSponsorOnly = isSponsorOnly
        self.isSuperSponsorOnly = isSuperSponsorOnly
        self.isArtShow = isArtShow
        self.isKageEvent = isKageEvent
        self.isDealersDen = isDealersDen
        self.isMainStage = isMainStage
        self.isPhotoshoot = isPhotoshoot

        favouritedState = .unset
    }

    private(set) public var favouritedState: FavouritedState
    public func favourite() {
        favouritedState = .favourited
    }

}

extension StubEvent: RandomValueProviding {

    public static var random: StubEvent {
        let startDate = Date.random
        return StubEvent(identifier: .random,
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

    public static var randomStandardEvent: StubEvent {
        let event = StubEvent.random
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
