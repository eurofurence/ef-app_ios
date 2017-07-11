//
//  UserAcknowledgedPushPermissionsRequestStateProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol UserAcknowledgedPushPermissionsRequestStateProviding {

    var userHasAcknowledgedRequestForPushPermissions: Bool { get }

}
