//
//  TutorialModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct TutorialModule {

    static func initialize(context: ApplicationContext, routers: Routers) {
        let tutorialScene = routers.tutorialRouter.showTutorial()
        let tutorialPages = context.tutorialItems
        _ = TutorialPresenter(tutorialScene: tutorialScene, tutorialPages: tutorialPages)
    }

}
