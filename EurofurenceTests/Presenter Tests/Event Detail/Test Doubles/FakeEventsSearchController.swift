//
//  FakeEventsSearchController.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeEventsSearchController: EventsSearchController {
    
    private(set) var capturedSearchTerm: String?
    func changeSearchTerm(_ term: String) {
        capturedSearchTerm = term
    }
    
}
