//
//  EurofurenceApplicationProtocol.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

enum EurofurenceDataStoreState {
    case absent
    case stale
    case available
}

protocol EurofurenceApplicationProtocol {

    var localPrivateMessages: [Message] { get }

    func resolveDataStoreState(completionHandler: @escaping (EurofurenceDataStoreState) -> Void)
    func retrieveCurrentUser(completionHandler: @escaping (User?) -> Void)
    func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void)
    func login(_ arguments: LoginArguments, completionHandler: @escaping (LoginResult) -> Void)

}
