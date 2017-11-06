//
//  PhoneTutorialSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIStoryboard

struct PhoneTutorialSceneFactory: TutorialSceneFactory {

    func makeTutorialScene() -> UIViewController & TutorialScene {
        let storyboard = UIStoryboard(name: "Tutorial", bundle: .main)
        return storyboard.instantiateInitialViewController() as! TutorialViewController
    }

}
