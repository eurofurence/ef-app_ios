//
//  EurofurenceApplicationProtocol.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol EurofurenceApplicationProtocol {

    var localPrivateMessages: [Message] { get }

    func retrieveCurrentUser(completionHandler: @escaping (User?) -> Void)
    func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void)
    func login(_ arguments: LoginArguments, completionHandler: @escaping (LoginResult) -> Void)

}
