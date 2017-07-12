//
//  PresentationAssets.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

protocol PresentationAssets {

    var initialLoadInformationAsset: UIImage { get }
    var requestPushNotificationPermissionsAsset: UIImage { get }

}

struct ApplicationPresentationAssets: PresentationAssets {

    var initialLoadInformationAsset: UIImage = #imageLiteral(resourceName: "tuto01_notificationIcon")
    var requestPushNotificationPermissionsAsset: UIImage = UIImage()

}
