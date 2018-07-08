//
//  CapturingSyncAPI.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingSyncAPI: SyncAPI {
    
    fileprivate var completionHandler: ((APISyncResponse?) -> Void)?
    private(set) var capturedLastSyncTime: Date?
    private(set) var didBeginSync = false
    func fetchLatestData(lastSyncTime: Date?, completionHandler: @escaping (APISyncResponse?) -> Void) {
        didBeginSync = true
        capturedLastSyncTime = lastSyncTime
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
