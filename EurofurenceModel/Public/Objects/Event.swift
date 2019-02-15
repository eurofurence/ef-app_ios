//
//  Event.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public typealias EventIdentifier = Identifier<EventProtocol>

public protocol EventProtocol {

    var identifier: EventIdentifier { get }
    var title: String { get }
    var subtitle: String { get }
    var abstract: String { get }
    var room: Room { get }
    var track: Track { get }
    var hosts: String { get }
    var startDate: Date { get }
    var endDate: Date { get }
    var eventDescription: String { get }
    var posterGraphicPNGData: Data? { get }
    var bannerGraphicPNGData: Data? { get }
    var isSponsorOnly: Bool { get }
    var isSuperSponsorOnly: Bool { get }
    var isArtShow: Bool { get }
    var isKageEvent: Bool { get }
    var isDealersDen: Bool { get }
    var isMainStage: Bool { get }
    var isPhotoshoot: Bool { get }

}

struct Event: EventProtocol {

    var identifier: EventIdentifier
    var title: String
    var subtitle: String
    var abstract: String
    var room: Room
    var track: Track
    var hosts: String
    var startDate: Date
    var endDate: Date
    var eventDescription: String
    var posterGraphicPNGData: Data?
    var bannerGraphicPNGData: Data?
    var isSponsorOnly: Bool
    var isSuperSponsorOnly: Bool
    var isArtShow: Bool
    var isKageEvent: Bool
    var isDealersDen: Bool
    var isMainStage: Bool
    var isPhotoshoot: Bool

    init(identifier: EventIdentifier, title: String, subtitle: String, abstract: String, room: Room, track: Track, hosts: String, startDate: Date, endDate: Date, eventDescription: String, posterGraphicPNGData: Data?, bannerGraphicPNGData: Data?, isSponsorOnly: Bool, isSuperSponsorOnly: Bool, isArtShow: Bool, isKageEvent: Bool, isDealersDen: Bool, isMainStage: Bool, isPhotoshoot: Bool) {
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
    }

}
