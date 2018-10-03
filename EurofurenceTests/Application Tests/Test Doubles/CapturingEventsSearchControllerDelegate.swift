//
//  CapturingEventsSearchControllerDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Eurofurence
import Foundation

class CapturingEventsSearchControllerDelegate: EventsSearchControllerDelegate {
    
    private(set) var toldSearchResultsUpdatedToEmptyArray = false
    private(set) var capturedSearchResults = [Event2]()
    func searchResultsDidUpdate(to results: [Event2]) {
        toldSearchResultsUpdatedToEmptyArray = results.isEmpty
        capturedSearchResults = results
    }
    
}
