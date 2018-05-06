//
//  CapturingPreloadServiceDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingPreloadServiceDelegate: PreloadInteractorDelegate {
    
    private(set) var wasToldpreloadInteractorDidFailToPreload = false
    func preloadInteractorDidFailToPreload() {
        wasToldpreloadInteractorDidFailToPreload = true
    }
    
    private(set) var wasToldpreloadInteractorDidFinishPreloading = false
    func preloadInteractorDidFinishPreloading() {
        wasToldpreloadInteractorDidFinishPreloading = true
    }
    
    private(set) var capturedProgressCurrentUnitCount: Int?
    private(set) var capturedProgressTotalUnitCount: Int?
    func preloadInteractorDidProgress(currentUnitCount: Int, totalUnitCount: Int) {
        capturedProgressCurrentUnitCount = currentUnitCount
        capturedProgressTotalUnitCount = totalUnitCount
    }
    
}
