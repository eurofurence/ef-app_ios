//
//  PrivateMessageResult.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 28/12/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public enum PrivateMessageResult {
    case success([Message])
    case failedToLoad
    case userNotAuthenticated
}
