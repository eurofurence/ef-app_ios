//
//  MessagesModuleFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

protocol MessagesModuleFactory {

    func makeMessagesModule(_ delegate: MessagesModuleDelegate) -> UIViewController

}

protocol MessagesModuleDelegate {

    func messagesModuleDidRequestResolutionForUser(completionHandler: @escaping (Bool) -> Void)
    func messagesModuleDidRequestDismissal()

}
