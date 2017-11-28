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

    func show(_ alert: Alert) {
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        for action in alert.actions {
            alertController.addAction(UIAlertAction(title: action.title, style: .default, handler: { (_) in
                // TODO: Figure out a nice way of testing this as UIAlertAction does not expose the handler
                action.invoke()
                alertController.dismiss(animated: true)
            }))
        }

        struct DummyAlertDismissable: AlertDismissable {
            func dismiss(_ completionHandler: (() -> Void)?) {

            }
        }

        window.rootViewController?.present(alertController, animated: true) { (_) in
            alert.onCompletedPresentation?(DummyAlertDismissable())
        }
    }
}
