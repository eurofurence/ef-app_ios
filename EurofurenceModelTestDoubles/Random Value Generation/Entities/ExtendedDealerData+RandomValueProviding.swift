//
//  ExtendedDealerData.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import TestUtilities

extension ExtendedDealerData: RandomValueProviding {

    public static var random: ExtendedDealerData {
        return ExtendedDealerData(artistImagePNGData: .random,
                                  dealersDenMapLocationGraphicPNGData: .random,
                                  preferredName: .random,
                                  alternateName: .random,
                                  categories: .random,
                                  dealerShortDescription: .random,
                                  isAttendingOnThursday: .random,
                                  isAttendingOnFriday: .random,
                                  isAttendingOnSaturday: .random,
                                  isAfterDark: .random,
                                  websiteName: .random,
                                  twitterUsername: .random,
                                  telegramUsername: .random,
                                  aboutTheArtist: .random,
                                  aboutTheArt: .random,
                                  artPreviewImagePNGData: .random,
                                  artPreviewCaption: .random)
    }

}
