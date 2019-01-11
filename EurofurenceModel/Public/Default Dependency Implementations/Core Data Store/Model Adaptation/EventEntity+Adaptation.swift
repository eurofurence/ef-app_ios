//
//  EventEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension EventEntity: EntityAdapting {

    typealias AdaptedType = APIEvent

    func asAdaptedType() -> APIEvent {
        return APIEvent(identifier: identifier!,
                        roomIdentifier: roomIdentifier!,
                        trackIdentifier: trackIdentifier!,
                        dayIdentifier: dayIdentifier!,
                        startDateTime: startDateTime! as Date,
                        endDateTime: endDateTime! as Date,
                        title: title!,
                        subtitle: subtitle.or(""),
                        abstract: abstract!,
                        panelHosts: panelHosts!,
                        eventDescription: eventDescription!,
                        posterImageId: posterImageId,
                        bannerImageId: bannerImageId,
                        tags: tags)
    }

    func consumeAttributes(from value: APIEvent) {
        identifier = value.identifier
        roomIdentifier = value.roomIdentifier
        trackIdentifier = value.trackIdentifier
        dayIdentifier = value.dayIdentifier
        startDateTime = value.startDateTime
        endDateTime = value.endDateTime
        title = value.title
        subtitle = value.subtitle
        abstract = value.abstract
        panelHosts = value.panelHosts
        eventDescription = value.eventDescription
        posterImageId = value.posterImageId
        bannerImageId = value.bannerImageId
        tags = value.tags
    }

}
