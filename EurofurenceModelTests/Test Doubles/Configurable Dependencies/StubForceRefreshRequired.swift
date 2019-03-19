//
//  StubForceRefreshRequired.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class StubForceRefreshRequired: ForceRefreshRequired {

    var isForceRefreshRequired: Bool
    
    func markForceRefreshNoLongerRequired() {
        isForceRefreshRequired = false
    }
    
    init(isForceRefreshRequired: Bool) {
        self.isForceRefreshRequired = isForceRefreshRequired
    }

}
