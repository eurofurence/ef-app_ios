//
//  NewsScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol NewsScene {

    func showMessagesNavigationAction()
    func hideMessagesNavigationAction()

    func showLoginNavigationAction()
    func hideLoginNavigationAction()

    func showWelcomePrompt(_ prompt: String)
    func showLoginPrompt(_ prompt: String)

}
