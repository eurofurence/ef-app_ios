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
    func showAlert(title: String, message: String) {
        didShowAlert = true
        presentedAlertTitle = title
        presentedAlertMessage = message
    }
    
}
