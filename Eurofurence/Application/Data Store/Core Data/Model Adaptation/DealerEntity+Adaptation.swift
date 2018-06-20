//
//  DealerEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension DealerEntity: EntityAdapting {

    typealias AdaptedType = APIDealer

    func asAdaptedType() -> APIDealer {
        return APIDealer(identifier: identifier!,
                         displayName: displayName!,
                         attendeeNickname: attendeeNickname!,
                         attendsOnThursday: attendsOnThursday,
                         attendsOnFriday: attendsOnFriday,
                         attendsOnSaturday: attendsOnSaturday,
                         isAfterDark: isAfterDark,
                         artistThumbnailImageId: artistThumbnailImageId)
    }

}
