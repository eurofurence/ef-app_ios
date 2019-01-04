//
//  PrivateMessagesObserver.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

public protocol PrivateMessagesObserver {

    func privateMessagesServiceDidFinishRefreshingMessages(messages: [Message])
    func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int)
    func privateMessagesServiceDidFailToLoadMessages()

}
