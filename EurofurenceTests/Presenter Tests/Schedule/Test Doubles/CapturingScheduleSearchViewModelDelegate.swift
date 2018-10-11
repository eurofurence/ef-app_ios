//
//  CapturingScheduleSearchViewModelDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import Foundation

class CapturingScheduleSearchViewModelDelegate: ScheduleSearchViewModelDelegate {

    private(set) var capturedSearchResults = [ScheduleEventGroupViewModel]()
    func scheduleSearchResultsUpdated(_ results: [ScheduleEventGroupViewModel]) {
        capturedSearchResults = results
    }

}
