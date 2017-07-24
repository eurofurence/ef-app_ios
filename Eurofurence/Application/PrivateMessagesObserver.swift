//
//  PrivateMessagesObserver.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol PrivateMessagesObserver {

    func privateMessagesAvailable(_ privateMessages: [Message])
    func failedToLoadPrivateMessages()
    func userNotAuthenticatedForPrivateMessages()

}
