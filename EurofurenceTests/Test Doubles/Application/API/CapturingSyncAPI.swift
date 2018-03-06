//
//  CapturingSyncAPI.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingSyncAPI: SyncAPI {
    
    fileprivate var completionHandler: ((APISyncResponse?) -> Void)?
    func fetchLatestData(completionHandler: @escaping (APISyncResponse?) -> Void) {
        self.completionHandler = completionHandler
    }
    
}

extension CapturingSyncAPI {
    
    func simulateSuccessfulSync(_ response: APISyncResponse) {
        completionHandler?(response)
    }
    func simulateUnsuccessfulSync() {
        completionHandler?(nil)
    }
    
}
