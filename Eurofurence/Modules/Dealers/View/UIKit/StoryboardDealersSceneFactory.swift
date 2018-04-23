//
//  StoryboardDealersSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct StoryboardDealersSceneFactory: DealersSceneFactory {

    private let storyboard = UIStoryboard(name: "Dealers", bundle: .main)

    func makeDealersScene() -> UIViewController & DealersScene {
        return storyboard.instantiate(DealersViewController.self)
    }

}
