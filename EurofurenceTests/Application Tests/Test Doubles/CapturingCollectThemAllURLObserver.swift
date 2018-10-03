//
//  CapturingCollectThemAllURLObserver.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Eurofurence
import Foundation

class CapturingCollectThemAllURLObserver: CollectThemAllURLObserver {
    
    private(set) var capturedURLRequest: URLRequest?
    func collectThemAllGameRequestDidChange(_ urlRequest: URLRequest) {
        capturedURLRequest = urlRequest
    }
    
}
