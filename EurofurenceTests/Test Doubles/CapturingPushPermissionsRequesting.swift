//
//  CapturingPushPermissionsRequesting.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingPushPermissionsRequesting: PushPermissionsRequesting {

    private(set) var didRequestPermission = false
    private(set) var completionHandler: (() -> Void)?
    func requestPushPermissions(completionHandler: @escaping () -> Void) {
        didRequestPermission = true
        self.completionHandler = completionHandler
    }

    func completeRegistrationRequest() {
        completionHandler?()
    }
    
}
