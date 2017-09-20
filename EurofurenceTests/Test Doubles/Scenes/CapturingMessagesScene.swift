//
//  CapturingMessagesScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingMessagesScene: MessagesScene {
    
    var delegate: MessagesSceneDelegate?
    
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
    
    private(set) var didShowMessages = false
    func showMessagesList() {
        didShowMessages = true
    }
    
    private(set) var didHideMessages = false
    func hideMessagesList() {
        didHideMessages = true
    }
    
    private(set) var didShowNoMessagesPlaceholder = false
    func showNoMessagesPlaceholder() {
        didShowNoMessagesPlaceholder = true
    }
    
    private(set) var didHideNoMessagesPlaceholder = false
    func hideNoMessagesPlaceholder() {
        didHideNoMessagesPlaceholder = true
    }
    
    func tapMessage(at index: Int) {
        delegate?.messagesSceneDidSelectMessage(at: IndexPath(indexes: [0, index]))
    }
    
}

class CapturingMessagesSceneDelegate: MessagesSceneDelegate {
    
    private(set) var capturedSelectedMessageIndexPath: IndexPath?
    func messagesSceneDidSelectMessage(at indexPath: IndexPath) {
        capturedSelectedMessageIndexPath = indexPath
    }
    
}
