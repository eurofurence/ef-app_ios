//
//  StoryboardCollectThemAllSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct StoryboardCollectThemAllSceneFactory: CollectThemAllSceneFactory {

    private let storyboard = UIStoryboard(name: "CollectThemAll", bundle: .main)

    func makeCollectThemAllScene() -> UIViewController & CollectThemAllScene {
        return storyboard.instantiate(CollectThemAllViewController.self)
    }

}
