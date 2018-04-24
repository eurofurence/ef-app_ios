//
//  NewsScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol NewsSceneDelegate {

    func newsSceneWillAppear()
    func newsSceneDidSelectComponent(at indexPath: IndexPath)

    func newsSceneDidTapLoginAction(_ scene: NewsScene)
    func newsSceneDidTapShowMessagesAction(_ scene: NewsScene)

}

protocol NewsScene: class {

    var delegate: NewsSceneDelegate? { get set }

    func showNewsTitle(_ title: String)

    func showMessagesNavigationAction()
    func hideMessagesNavigationAction()

    func showLoginNavigationAction()
    func hideLoginNavigationAction()

    func showWelcomePrompt(_ prompt: String)
    func showWelcomeDescription(_ description: String)

    func showLoginPrompt(_ prompt: String)
    func showLoginDescription(_ description: String)

    func bind(numberOfItemsPerComponent: [Int], using binder: NewsComponentsBinder)

}
