//
//  CapturingRefreshServiceObserver.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class CapturingRefreshServiceObserver: RefreshServiceObserver {

    private(set) var toldDidBeginRefreshing = false
    func refreshServiceDidBeginRefreshing() {
        toldDidBeginRefreshing = true
    }

    private(set) var toldDidFinishRefreshing = false
    func refreshServiceDidFinishRefreshing() {
        toldDidFinishRefreshing = true
    }

}
