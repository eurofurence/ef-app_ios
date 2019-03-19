//
//  CapturingRefreshServiceObserver.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class CapturingRefreshServiceObserver: RefreshServiceObserver {
    
    enum State {
        case unset
        case refreshing
        case finishedRefreshing
    }
    
    private(set) var state: State = .unset

    func refreshServiceDidBeginRefreshing() {
        state = .refreshing
    }

    func refreshServiceDidFinishRefreshing() {
        state = .finishedRefreshing
    }

}
