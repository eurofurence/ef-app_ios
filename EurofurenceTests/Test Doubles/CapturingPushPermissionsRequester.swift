//
//  CapturingPushPermissionsRequester.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

class CapturingPushPermissionsRequester: PushPermissionsRequester {
    
    private(set) var wasToldToRequestPushPermissions = false
    func requestPushPermissions() {
        wasToldToRequestPushPermissions = true
    }
    
}
