//
//  PrivateMessagesService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public protocol PrivateMessagesService {

    func add(_ observer: PrivateMessagesObserver)
    func refreshMessages()
    func markMessageAsRead(_ message: APIMessage)

}

public protocol PrivateMessagesObserver {
    
    func privateMessagesServiceDidFinishRefreshingMessages(messages: [APIMessage])
    func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int)
    func privateMessagesServiceDidFailToLoadMessages()
    
}
