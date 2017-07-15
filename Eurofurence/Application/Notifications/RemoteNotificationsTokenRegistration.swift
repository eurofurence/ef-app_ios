//
//  RemoteNotificationsTokenRegistration.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol RemoteNotificationsTokenRegistration {

    func registerRemoteNotificationsDeviceToken(_ token: Data)

}
