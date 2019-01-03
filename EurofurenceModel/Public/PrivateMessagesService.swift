//
//  PrivateMessagesService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 28/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

public protocol PrivateMessagesService {

    func add(_ observer: PrivateMessagesServiceObserver)
    func refreshMessages()
    func markMessageAsRead(_ message: Message)

}

public protocol PrivateMessagesServiceObserver {

    func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int)
    func privateMessagesServiceDidFinishRefreshingMessages(_ messages: [Message])
    func privateMessagesServiceDidFailToLoadMessages()

}
