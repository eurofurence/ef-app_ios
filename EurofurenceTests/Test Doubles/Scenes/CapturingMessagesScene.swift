//
//  CapturingMessagesScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingMessagesScene: MessagesScene {
    
    private(set) var wasToldToShowRefreshIndicator = false
    func showRefreshIndicator() {
        wasToldToShowRefreshIndicator = true
    }
    
    private(set) var wasToldToHideRefreshIndicator = false
    func hideRefreshIndicator() {
        wasToldToHideRefreshIndicator = true
    }
    
    private(set) var capturedMessagesViewModel: MessagesViewModel?
    func showMessages(_ viewModel: MessagesViewModel) {
        capturedMessagesViewModel = viewModel
    }
    
}
