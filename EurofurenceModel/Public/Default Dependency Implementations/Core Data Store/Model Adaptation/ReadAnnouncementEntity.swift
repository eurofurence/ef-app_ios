//
//  ReadAnnouncementEntity.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension ReadAnnouncementEntity: EntityAdapting {

    typealias AdaptedType = AnnouncementIdentifier

    func asAdaptedType() -> AnnouncementIdentifier {
        return AnnouncementIdentifier(announcementIdentifier!)
    }

    func consumeAttributes(from value: AnnouncementIdentifier) {
        announcementIdentifier = value.rawValue
    }

}
