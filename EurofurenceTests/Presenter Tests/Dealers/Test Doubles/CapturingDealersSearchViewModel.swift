//
//  CapturingDealersSearchViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingDealersSearchViewModel: DealersSearchViewModel {
    
    private(set) var capturedSearchQuery: String?
    func updateSearchResults(with query: String) {
        capturedSearchQuery = query
    }
    
}
