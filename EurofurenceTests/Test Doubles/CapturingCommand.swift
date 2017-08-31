//
//  CapturingCommand.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 31/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingCommand: Command {
    
    private(set) var wasRan = false
    func run() {
        wasRan = true
    }
    
}
