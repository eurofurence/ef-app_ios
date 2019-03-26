//
//  DealerCharacteristics+RandomValueProviding.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 19/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import TestUtilities

extension DealerCharacteristics: RandomValueProviding {
    
    public static var random: DealerCharacteristics {
        return DealerCharacteristics(identifier: .random,
                                     displayName: .random,
                                     attendeeNickname: .random,
                                     attendsOnThursday: .random,
                                     attendsOnFriday: .random,
                                     attendsOnSaturday: .random,
                                     isAfterDark: .random,
                                     artistThumbnailImageId: .random,
                                     artistImageId: .random,
                                     artPreviewImageId: .random,
                                     categories: .random,
                                     shortDescription: .random,
                                     links: [LinkCharacteristics].random.sorted(),
                                     twitterHandle: .random,
                                     telegramHandle: .random,
                                     aboutTheArtistText: .random,
                                     aboutTheArtText: .random,
                                     artPreviewCaption: .random)
    }
    
}
