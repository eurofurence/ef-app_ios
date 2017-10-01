//
//  CapturingPreloadService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingPreloadService: PreloadService {
    
    private(set) var didBeginPreloading = false
    private(set) var beginPreloadInvocationCount = 0
    private var delegate: PreloadServiceDelegate?
    func beginPreloading(delegate: PreloadServiceDelegate) {
        self.delegate = delegate
        didBeginPreloading = true
        beginPreloadInvocationCount += 1
    }
    
    func notifyFailedToPreload() {
        delegate?.preloadServiceDidFail()
    }
    
    func notifySucceededPreload() {
        delegate?.preloadServiceDidFinish()
    }
    
    func notifyProgressMade(current: Int, total: Int) {
        delegate?.preloadServiceDidProgress(currentUnitCount: current, totalUnitCount: total)
    }
    
}
