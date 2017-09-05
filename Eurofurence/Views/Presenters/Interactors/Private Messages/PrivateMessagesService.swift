//
//  PrivateMessagesService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 28/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

enum PrivateMessagesRefreshResult {
    case success([Message])
    case failure
}

protocol PrivateMessagesService {

    var unreadMessageCount: Int { get }
    var localMessages: [Message] { get }

    func refreshMessages(completionHandler: @escaping (PrivateMessagesRefreshResult) -> Void)

}
