//
//  MessagesPresenterDelegateTestDoubles.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

struct DummyMessagesPresenterDelegate: MessagesPresenterDelegate {
    
    func dismissMessagesScene() { }
    
}

class CapturingMessagesPresenterDelegate: MessagesPresenterDelegate {
    
    private(set) var wasToldToDismissMessagesScene = false
    func dismissMessagesScene() {
        wasToldToDismissMessagesScene = true
    }
    
}
