//
//  CapturingPreloadModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingPreloadModuleDelegate: PreloadModuleDelegate {
    
    private(set) var notifiedPreloadCancelled = false
    func preloadModuleDidCancelPreloading() {
        notifiedPreloadCancelled = true
    }
    
    private(set) var notifiedPreloadFinished = false
    func preloadModuleDidFinishPreloading() {
        notifiedPreloadFinished = true
    }
    
}
