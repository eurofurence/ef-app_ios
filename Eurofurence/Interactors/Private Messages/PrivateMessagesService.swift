//
//  PrivateMessagesService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 28/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol PrivateMessagesService {

    var localMessages: [Message] { get }

    func add(_ observer: PrivateMessagesServiceObserver)
    func refreshMessages()

}

protocol PrivateMessagesServiceObserver {

    func privateMessagesServiceDidUpdateUnreadMessageCount(to unreadCount: Int)
    func privateMessagesServiceDidFinishRefreshingMessages(_ messages: [Message])
    func privateMessagesServiceDidFailToLoadMessages()

}
