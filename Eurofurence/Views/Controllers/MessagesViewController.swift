//
//  MessagesViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

protocol MessagesViewControllerDelegate: class {

    func messagesViewControllerDidRequestDismissal(_ messagesController: MessagesViewController)

}

class MessagesViewController: UITableViewController,
                              AuthenticationStateObserver,
                              LoginViewControllerDelegate {

    // MARK: Properties

    weak var messagesDelegate: MessagesViewControllerDelegate?
    private var isLoggedIn = false
    private var didShowLogin = false

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        EurofurenceApplication.shared.add(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if !(isLoggedIn || didShowLogin) {
            didShowLogin = true
            performSegue(withIdentifier: "showTutorial", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let destination = segue.destination as? UINavigationController,
           let login = destination.topViewController as? LoginViewController {
            login.loginDelegate = self
        }
    }

    // MARK: AuthenticationStateObserver

    func loggedIn(as user: User) {
        isLoggedIn = true
    }

    // MARK: LoginViewControllerDelegate

    func loginViewControllerDidLoginSuccessfully(_ loginController: LoginViewController) {
        dismiss(animated: true) {
            // TODO: This is where we'd show messages
        }
    }

    func loginViewControllerDidCancel(_ loginController: LoginViewController) {
        dismiss(animated: true) {
            self.messagesDelegate?.messagesViewControllerDidRequestDismissal(self)
        }
    }

}
