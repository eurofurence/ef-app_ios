//
//  ReadAnnouncementEntity.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension ReadAnnouncementEntity: EntityAdapting {

    typealias AdaptedType = Announcement2.Identifier

    func asAdaptedType() -> Announcement2.Identifier {
        return Announcement2.Identifier(announcementIdentifier!)
    }

}
