//
//  WindowAlertRouter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

struct WindowAlertRouter: AlertRouter {
    var window: UIWindow

    func showAlert(title: String, message: String, actions: AlertAction ...) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(UIAlertAction(title: action.title, style: .default, handler: { (_) in
                // TODO: Figure out a nice way of testing this as UIAlertAction does not expose the handler
                action.invoke()
                alert.dismiss(animated: true)
            }))
        }

        window.rootViewController?.present(alert, animated: true)
    }
}
