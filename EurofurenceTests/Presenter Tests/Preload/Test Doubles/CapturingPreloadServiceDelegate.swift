//
//  CapturingPreloadServiceDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingPreloadServiceDelegate: PreloadServiceDelegate {
    
    private(set) var wasToldPreloadServiceDidFail = false
    func preloadServiceDidFail() {
        wasToldPreloadServiceDidFail = true
    }
    
    private(set) var wasToldPreloadServiceDidFinish = false
    func preloadServiceDidFinish() {
        wasToldPreloadServiceDidFinish = true
    }
    
    func preloadServiceDidProgress(currentUnitCount: Int, totalUnitCount: Int) {
        
    }
    
}
