//
//  CapturingAlertRouter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingAlertRouter: AlertRouter {

    private(set) var didShowAlert = false
    private(set) var presentedAlertTitle: String?
    private(set) var presentedAlertMessage: String?
    private(set) var presentedActions = [AlertAction]()
    func show(_ alert: Alert) {
        didShowAlert = true
        presentedAlertTitle = alert.title
        presentedAlertMessage = alert.message
        presentedActions = alert.actions
    }
    
    func capturedAction(title: String) -> AlertAction? {
        return presentedActions.first(where: { $0.title == title })
    }
    
}
