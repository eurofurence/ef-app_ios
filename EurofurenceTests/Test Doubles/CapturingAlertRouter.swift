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
    func showAlert(title: String, message: String, actions: AlertAction ...) {
        didShowAlert = true
        presentedAlertTitle = title
        presentedAlertMessage = message
        presentedActions = actions
    }
    
    func capturedAction(title: String) -> AlertAction? {
        return presentedActions.first(where: { $0.title == title })
    }
    
}
