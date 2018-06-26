//
//  StoryboardMapsScenefactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct StoryboardMapsScenefactory: MapsSceneFactory {

    private let storyboard = UIStoryboard(name: "Maps", bundle: .main)

    func makeMapsScene() -> UIViewController & MapsScene {
        return storyboard.instantiate(MapsViewController.self)
    }

}
