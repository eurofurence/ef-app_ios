//
//  CapturingMessagesScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation
import UIKit.UIViewController

class StubMessagesSceneFactory: MessagesSceneFactory {
    
    let scene = CapturingMessagesScene()
    func makeMessagesScene() -> UIViewController & MessagesScene {
        return scene
    }
    
}

class CapturingMessagesScene: UIViewController, MessagesScene {
    
    var delegate: MessagesSceneDelegate?
    
    private(set) var capturedTitle: String?
    func setMessagesTitle(_ title: String) {
        capturedTitle = title
    }
    
    private(set) var wasToldToShowRefreshIndicator = false
    func showRefreshIndicator() {
        wasToldToShowRefreshIndicator = true
    }
    
    private(set) var wasToldToHideRefreshIndicator = false
    func hideRefreshIndicator() {
        wasToldToHideRefreshIndicator = true
    }
    
    private(set) var capturedMessageItemBinder: MessageItemBinder?
    func bindMessages(with binder: MessageItemBinder) {
        capturedMessageItemBinder = binder
    }
    
    private(set) var didShowMessages = false
    func showMessagesList() {
        didShowMessages = true
    }
    
    private(set) var didHideMessages = false
    func hideMessagesList() {
        didHideMessages = true
    }
    
    var didShowNoMessagesPlaceholder = false
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

class CapturingMessageItemScene: MessageItemScene {
    
    private(set) var capturedAuthor: String?
    func presentAuthor(_ author: String) {
        capturedAuthor = author
    }
    
    private(set) var capturedSubject: String?
    func presentSubject(_ subject: String) {
        capturedSubject = subject
    }
    
    private(set) var capturedContents: String?
    func presentContents(_ contents: String) {
        capturedContents = contents
    }
    
    private(set) var capturedReceivedDateTime: String?
    func presentReceivedDateTime(_ dateTime: String) {
        capturedReceivedDateTime = dateTime
    }
    
    private(set) var didShowUnreadIndicator = false
    func showUnreadIndicator() {
        didShowUnreadIndicator = true
    }
    
    private(set) var didHideUnreadIndicator = false
    func hideUnreadIndicator() {
        didHideUnreadIndicator = true
    }
    
}

class CapturingMessagesSceneDelegate: MessagesSceneDelegate {
    
    private(set) var toldMessagesSceneWillAppear = false
    func messagesSceneWillAppear() {
        toldMessagesSceneWillAppear = true
    }
    
    private(set) var capturedSelectedMessageIndexPath: IndexPath?
    func messagesSceneDidSelectMessage(at indexPath: IndexPath) {
        capturedSelectedMessageIndexPath = indexPath
    }
    
    func messagesSceneDidPerformRefreshAction() {
        
    }
    
}
