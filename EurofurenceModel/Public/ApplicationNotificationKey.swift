//
//  ApplicationNotificationKey.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 22/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public enum ApplicationNotificationKey: String, Codable {
    case notificationContentKind
    case notificationContentIdentifier
}

public enum ApplicationNotificationContentKind: String, Codable {
    case event
}
