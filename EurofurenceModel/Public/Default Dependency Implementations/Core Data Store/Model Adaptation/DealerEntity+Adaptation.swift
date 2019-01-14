//
//  DealerEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension DealerEntity: EntityAdapting {

    typealias AdaptedType = DealerCharacteristics

    static func makeIdentifyingPredicate(for model: DealerCharacteristics) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.identifier)
    }

    func asAdaptedType() -> DealerCharacteristics {
        let linksArray = (links?.allObjects as? [LinkEntity])?.map({ $0.asAdaptedType() })
        return DealerCharacteristics(identifier: identifier!,
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
                         aboutTheArtText: aboutTheArtText!,
                         artPreviewCaption: artPreviewCaption!)
    }

    func consumeAttributes(from value: DealerCharacteristics) {
        identifier = value.identifier
        displayName = value.displayName
        attendeeNickname = value.attendeeNickname
        attendsOnThursday = value.attendsOnThursday
        attendsOnFriday = value.attendsOnFriday
        attendsOnSaturday = value.attendsOnSaturday
        isAfterDark = value.isAfterDark
        artistThumbnailImageId = value.artistThumbnailImageId
        artistImageId = value.artistImageId
        artPreviewImageId = value.artPreviewImageId
        categories = value.categories
        dealerShortDescription = value.shortDescription
        twitterHandle = value.twitterHandle
        telegramHandle = value.telegramHandle
        aboutTheArtist = value.aboutTheArtistText
        aboutTheArtText = value.aboutTheArtText
        artPreviewCaption = value.artPreviewCaption
    }

}
