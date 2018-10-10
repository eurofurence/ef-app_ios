//
//  AnnouncementDetailModuleProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import UIKit.UIViewController

protocol AnnouncementDetailModuleProviding {

    func makeAnnouncementDetailModule(for announcement: Announcement.Identifier) -> UIViewController

}
