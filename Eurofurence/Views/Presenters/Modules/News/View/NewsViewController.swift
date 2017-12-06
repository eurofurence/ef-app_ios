//
//  NewsViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIGestureRecognizer
import UIKit.UIViewController

class NewsViewController: UIViewController, NewsScene {

    // MARK: IBOutlets

    @IBOutlet weak var loginNavigationAction: UIView!
    @IBOutlet weak var loginNavigationTrigger: UIButton!

    // MARK: IBActions

    @IBAction func loginNavigationActionTapped(_ sender: Any) {
        delegate?.newsSceneDidTapLoginAction(self)
    }

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        loginNavigationAction.isHidden = true
    }

    // MARK: NewsScene

    var delegate: NewsSceneDelegate?

    func showMessagesNavigationAction() {

    }

    func hideMessagesNavigationAction() {

    }

    func showLoginNavigationAction() {
        loginNavigationAction.isHidden = false
    }

    func hideLoginNavigationAction() {
        loginNavigationAction.isHidden = true
    }

    func showWelcomePrompt(_ prompt: String) {

    }

    func showWelcomeDescription(_ description: String) {

    }

    func showLoginPrompt(_ prompt: String) {

    }

    func showLoginDescription(_ description: String) {

    }

}
