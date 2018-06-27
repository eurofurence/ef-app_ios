//
//  StoryboardMapDetailSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct StoryboardMapDetailSceneFactory: MapDetailSceneFactory {

    private let storyboard = UIStoryboard(name: "MapDetail", bundle: .main)

    func makeMapDetailScene() -> UIViewController & MapDetailScene {
        return storyboard.instantiate(MapDetailViewController.self)
    }

}
