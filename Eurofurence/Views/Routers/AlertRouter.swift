//
//  AlertRouter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol AlertRouter {

    func show(_ alert: Alert)

}

struct Alert {

    var title: String
    var message: String
    var actions: [AlertAction]
    var onCompletedPresentation: (() -> Void)?

    init(title: String, message: String, actions: [AlertAction] = []) {
        self.title = title
        self.message = message
        self.actions = actions
    }

}

struct AlertAction {

    var title: String
    private var action: (() -> Void)?

    init(title: String, action: (() -> Void)? = nil) {
        self.title = title
        self.action = action
    }

    func invoke() {
        action?()
    }

}
