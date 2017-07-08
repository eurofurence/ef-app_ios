//
//  TutorialPageInfo.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

struct TutorialPageInfo {

    var image: UIImage?
    var title: String?
    var description: String?
    private var primaryAction: TutorialPageAction?

    init(image: UIImage?,
         title: String?,
         description: String?,
         primaryAction: TutorialPageAction?) {
        self.image = image
        self.title = title
        self.description = description
        self.primaryAction = primaryAction
    }

    var primaryActionDescription: String? {
        return primaryAction?.actionDescription
    }

    func runPrimaryAction() {
        primaryAction?.runAction()
    }

}

struct TutorialPageAction {

    var actionDescription: String
    private var action: TutorialAction

    init(actionDescription: String, action: TutorialAction) {
        self.actionDescription = actionDescription
        self.action = action
    }

    func runAction() {
        action.run()
    }

}
