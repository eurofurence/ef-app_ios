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
    var secondaryAction: TutorialPageAction?

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

}

struct TutorialPageAction {

    var actionDescription: String
    private var action: TutorialAction

    init(actionDescription: String, action: TutorialAction) {
        self.actionDescription = actionDescription
        self.action = action
    }

    func runAction(_ delegate: TutorialActionDelegate) {
        action.run(delegate)
    }

}
