//
//  CapturingPreloadInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingPreloadInteractor: PreloadInteractor {
    
    private(set) var didBeginPreloading = false
    private(set) var beginPreloadInvocationCount = 0
    private var delegate: PreloadInteractorDelegate?
    func beginPreloading(delegate: PreloadInteractorDelegate) {
        self.delegate = delegate
        didBeginPreloading = true
        beginPreloadInvocationCount += 1
    }
    
    func notifyFailedToPreload() {
        delegate?.preloadInteractorDidFailToPreload()
    }
    
    func notifySucceededPreload() {
        delegate?.preloadInteractorDidFinishPreloading()
    }
    
    func notifyProgressMade(current: Int, total: Int) {
        delegate?.preloadInteractorDidProgress(currentUnitCount: current, totalUnitCount: total)
    }
    
}
