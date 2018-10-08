//
//  APIEvent.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct APIEvent: Equatable {

    public var identifier: String
    public var roomIdentifier: String
    public var trackIdentifier: String
    public var dayIdentifier: String
    public var startDateTime: Date
    public var endDateTime: Date
    public var title: String
    public var subtitle: String
    public var abstract: String
    public var panelHosts: String
    public var eventDescription: String
    public var posterImageId: String?
    public var bannerImageId: String?
    public var tags: [String]?

    public init(identifier: String, roomIdentifier: String, trackIdentifier: String, dayIdentifier: String, startDateTime: Date, endDateTime: Date, title: String, subtitle: String, abstract: String, panelHosts: String, eventDescription: String, posterImageId: String?, bannerImageId: String?, tags: [String]?) {
        self.identifier = identifier
        self.roomIdentifier = roomIdentifier
        self.trackIdentifier = trackIdentifier
        self.dayIdentifier = dayIdentifier
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.title = title
        self.subtitle = subtitle
        self.abstract = abstract
        self.panelHosts = panelHosts
        self.eventDescription = eventDescription
        self.posterImageId = posterImageId
        self.bannerImageId = bannerImageId
        self.tags = tags
    }

}
