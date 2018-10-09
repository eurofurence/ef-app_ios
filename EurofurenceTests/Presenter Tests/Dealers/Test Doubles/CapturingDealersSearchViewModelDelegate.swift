//
//  CapturingDealersSearchViewModelDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import Foundation

class CapturingDealersSearchViewModelDelegate: DealersSearchViewModelDelegate {
    
    private(set) var capturedSearchResults = [DealersGroupViewModel]()
    private(set) var capturedIndexTitles = [String]()
    func dealerSearchResultsDidChange(_ groups: [DealersGroupViewModel], indexTitles: [String]) {
        capturedSearchResults = groups
        capturedIndexTitles = indexTitles
    }
    
}
