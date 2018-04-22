//
//  StubMessagesModuleFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class StubMessagesModuleFactory: MessagesModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var delegate: MessagesModuleDelegate?
    func makeMessagesModule(_ delegate: MessagesModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

extension StubMessagesModuleFactory {
    
    func simulateResolutionForUser(_ handler: @escaping (Bool) -> Void) {
        delegate?.messagesModuleDidRequestResolutionForUser(completionHandler: handler)
    }
    
    func simulateMessagePresentationRequested(_ message: Message) {
        delegate?.messagesModuleDidRequestPresentation(for: message)
    }
    
    func simulateDismissalRequested() {
        delegate?.messagesModuleDidRequestDismissal()
    }
    
}
