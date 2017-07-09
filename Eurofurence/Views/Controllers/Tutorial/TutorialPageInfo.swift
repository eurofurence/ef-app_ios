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
    var primaryAction: TutorialPageAction?
    private var secondaryAction: TutorialPageAction?

    init(image: UIImage?,
         title: String?,
         description: String?,
         primaryAction: TutorialPageAction? = nil,
         secondaryAction: TutorialPageAction? = nil) {
        self.image = image
        self.title = title
        self.description = description
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }

    var primaryActionDescription: String? {
        return primaryAction?.actionDescription
    }

    var secondaryActionDescription: String? {
        return secondaryAction?.actionDescription
    }

    func runPrimaryAction() {
        primaryAction?.runAction()
    }

    func runSecondaryAction() {
        secondaryAction?.runAction()
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
