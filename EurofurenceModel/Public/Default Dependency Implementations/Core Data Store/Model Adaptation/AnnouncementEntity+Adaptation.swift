//
//  AnnouncementEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension AnnouncementEntity: EntityAdapting {

    typealias AdaptedType = APIAnnouncement

    static func makeIdentifyingPredicate(for model: APIAnnouncement) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.identifier)
    }

    func asAdaptedType() -> APIAnnouncement {
        return APIAnnouncement(identifier: identifier!,
                               title: title!,
                               content: content!,
                               lastChangedDateTime: lastChangedDateTime! as Date,
                               imageIdentifier: imageIdentifier)
    }

    func consumeAttributes(from value: APIAnnouncement) {
        identifier = value.identifier
        title = value.title
        content = value.content
        lastChangedDateTime = value.lastChangedDateTime
        imageIdentifier = value.imageIdentifier
    }

}
