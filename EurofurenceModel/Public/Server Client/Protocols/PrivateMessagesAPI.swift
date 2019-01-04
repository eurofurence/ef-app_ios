//
//  PrivateMessagesAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

public protocol PrivateMessagesAPI {

    func loadPrivateMessages(authorizationToken: String, completionHandler: @escaping ([APIMessage]?) -> Void)
    func markMessageWithIdentifierAsRead(_ identifier: String, authorizationToken: String)

}
