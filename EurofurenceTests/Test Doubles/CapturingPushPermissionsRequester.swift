//
//  CapturingPushPermissionsRequester.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingPushPermissionsRequester: PushPermissionsRequester {
    
    private(set) var wasToldToRequestPushPermissions = false
    fileprivate var completionHandler: (() -> Void)?
    func requestPushPermissions(completionHandler: @escaping () -> Void) {
        wasToldToRequestPushPermissions = true
        self.completionHandler = completionHandler
    }
    
}

extension CapturingPushPermissionsRequester {
    
    func completeRegistrationRequest() {
        completionHandler?()
    }
    
}
