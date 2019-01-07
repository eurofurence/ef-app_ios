//
//  FakeApplicationNotificationHandling.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class FakeApplicationNotificationHandling: NotificationService {

    private struct RegisteredAction {
        var payload: [String: String]
        var result: NotificationContent
    }

    private var actions = [RegisteredAction]()
    func handleNotification(payload: [String: String], completionHandler: @escaping (NotificationContent) -> Void) {
        guard let action = actions.first(where: { $0.payload == payload }) else { return }
        completionHandler(action.result)
    }

    func storeRemoteNotificationsToken(_ deviceToken: Data) {

    }

}

extension FakeApplicationNotificationHandling {

    func stub(_ result: NotificationContent, for payload: [String: String]) {
        actions.append(RegisteredAction(payload: payload, result: result))
    }

}
