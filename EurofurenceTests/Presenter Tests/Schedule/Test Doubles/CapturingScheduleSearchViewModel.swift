//
//  CapturingScheduleSearchViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingScheduleSearchViewModel: ScheduleSearchViewModel {
    
    private(set) var capturedSearchInput: String?
    func updateSearchResults(input: String) {
        capturedSearchInput = input
    }
    
}
