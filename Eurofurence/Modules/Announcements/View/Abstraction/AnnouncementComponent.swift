//
//  AnnouncementComponent.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol AnnouncementComponent {

    func setAnnouncementTitle(_ title: String)
    func setAnnouncementDetail(_ detail: String)
    func setAnnouncementReceivedDateTime(_ receivedDateTime: String)
    func hideUnreadIndicator()
    func showUnreadIndicator()

}
