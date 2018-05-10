//
//  EurofurenceApplicationProtocol.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

enum EurofurenceDataStoreState {
    case absent
    case stale
    case available
}

protocol EurofurenceApplicationProtocol: AnnouncementsService, KnowledgeService, LinkLookupService, DaysUntilConventionService {

    func refreshLocalStore(completionHandler: @escaping (Error?) -> Void) -> Progress

    var localPrivateMessages: [Message] { get }

    func requestPermissionsForPushNotifications()
    func storeRemoteNotificationsToken(_ deviceToken: Data)
    func resolveDataStoreState(completionHandler: @escaping (EurofurenceDataStoreState) -> Void)
    func retrieveCurrentUser(completionHandler: @escaping (User?) -> Void)

    func add(_ observer: PrivateMessagesObserver)
    func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void)
    func markMessageAsRead(_ message: Message)

    func login(_ arguments: LoginArguments, completionHandler: @escaping (LoginResult) -> Void)
    func logout(completionHandler: @escaping (LogoutResult) -> Void)

}
