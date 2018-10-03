//
//  ExtendedDealerData.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct ExtendedDealerData {

    public var artistImagePNGData: Data?
    public var dealersDenMapLocationGraphicPNGData: Data?
    public var preferredName: String
    public var alternateName: String?
    public var categories: [String]
    public var dealerShortDescription: String
    public var isAttendingOnThursday: Bool
    public var isAttendingOnFriday: Bool
    public var isAttendingOnSaturday: Bool
    public var isAfterDark: Bool
    public var websiteName: String?
    public var twitterUsername: String?
    public var telegramUsername: String?
    public var aboutTheArtist: String?
    public var aboutTheArt: String?
    public var artPreviewImagePNGData: Data?
    public var artPreviewCaption: String?

}
