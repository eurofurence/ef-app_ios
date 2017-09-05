//
//  CapturingShowMessageAction.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingShowMessageAction: ShowMessageAction {
    
    private(set) var capturedMessage: Message?
    func show(message: Message) {
        capturedMessage = message
    }
    
}
