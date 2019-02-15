//
//  Event.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public typealias EventIdentifier = Identifier<Event>

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

public struct Event: EventProtocol {

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

    public init(identifier: EventIdentifier, title: String, subtitle: String, abstract: String, room: Room, track: Track, hosts: String, startDate: Date, endDate: Date, eventDescription: String, posterGraphicPNGData: Data?, bannerGraphicPNGData: Data?, isSponsorOnly: Bool, isSuperSponsorOnly: Bool, isArtShow: Bool, isKageEvent: Bool, isDealersDen: Bool, isMainStage: Bool, isPhotoshoot: Bool) {
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
