//
//  CapturingSignificantTimeChangeAdapter.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

class CapturingSignificantTimeChangeAdapter: SignificantTimeChangeAdapter {

    private(set) var delegate: SignificantTimeChangeAdapterDelegate?
    func setDelegate(_ delegate: SignificantTimeChangeAdapterDelegate) {
        self.delegate = delegate
    }

}

extension CapturingSignificantTimeChangeAdapter {

    func simulateSignificantTimeChange() {
        delegate?.significantTimeChangeDidOccur()
    }

}
