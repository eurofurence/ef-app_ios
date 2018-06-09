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

    func asAdaptedType() -> APIAnnouncement {
        return APIAnnouncement(title: title!,
                               content: content!,
                               lastChangedDateTime: lastChangedDateTime! as Date)
    }

}
