//
//  FakeApplicationNotificationHandling.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

class FakeApplicationNotificationHandling: ApplicationNotificationHandling {
    
    private struct RegisteredAction {
        var payload: [String : String]
        var result: ApplicationPushActionResult
    }
    
    private var actions = [RegisteredAction]()
    func handleRemoteNotification(payload: [String : String], completionHandler: @escaping (ApplicationPushActionResult) -> Void) {
        guard let action = actions.first(where: { $0.payload == payload }) else { return }
        completionHandler(action.result)
    }
    
}

extension FakeApplicationNotificationHandling {
    
    func stub(_ result: ApplicationPushActionResult, for payload: [String : String]) {
        actions.append(RegisteredAction(payload: payload, result: result))
    }
    
}
