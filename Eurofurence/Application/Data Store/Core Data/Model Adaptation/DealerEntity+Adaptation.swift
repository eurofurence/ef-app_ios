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
        let linksArray = (links?.allObjects as? [LinkEntity])?.map({ $0.asAdaptedType() })
        return APIDealer(identifier: identifier!,
                         displayName: displayName!,
                         attendeeNickname: attendeeNickname!,
                         attendsOnThursday: attendsOnThursday,
                         attendsOnFriday: attendsOnFriday,
                         attendsOnSaturday: attendsOnSaturday,
                         isAfterDark: isAfterDark,
                         artistThumbnailImageId: artistThumbnailImageId,
                         artistImageId: artistImageId,
                         artPreviewImageId: artPreviewImageId,
                         categories: categories ?? [],
                         shortDescription: dealerShortDescription!,
                         links: linksArray?.sorted(),
                         twitterHandle: twitterHandle!,
                         telegramHandle: telegramHandle!,
                         aboutTheArtistText: aboutTheArtist!,
                         aboutTheArtText: aboutTheArtText!)
    }

}
