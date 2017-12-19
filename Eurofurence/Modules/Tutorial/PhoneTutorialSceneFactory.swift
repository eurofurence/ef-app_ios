//
//  PhoneTutorialSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIStoryboard

struct PhoneTutorialSceneFactory: TutorialSceneFactory {

    private let storyboard = UIStoryboard(name: "Tutorial", bundle: .main)

    func makeTutorialScene() -> UIViewController & TutorialScene {
        return storyboard.instantiate(TutorialViewController.self)
    }

}
