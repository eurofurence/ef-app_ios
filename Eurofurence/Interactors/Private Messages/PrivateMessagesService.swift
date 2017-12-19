//
//  PrivateMessagesService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 28/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

enum PrivateMessagesRefreshResult: Equatable {
    case success([Message])
    case failure

    static func ==(lhs: PrivateMessagesRefreshResult, rhs: PrivateMessagesRefreshResult) -> Bool {
        switch (lhs, rhs) {
        case (.failure, .failure):
            return true

        case (.success(let lhsMessages), .success(let rhsMessages)):
            return lhsMessages == rhsMessages

        default:
            return false
        }
    }
}

protocol PrivateMessagesService {

    var unreadMessageCount: Int { get }
    var localMessages: [Message] { get }

    func add(_ unreadMessageCountObserver: PrivateMessageUnreadCountObserver)
    func refreshMessages(completionHandler: @escaping (PrivateMessagesRefreshResult) -> Void)

}

protocol PrivateMessageUnreadCountObserver {

    func unreadPrivateMessagesCountDidChange(to unreadCount: Int)

}
