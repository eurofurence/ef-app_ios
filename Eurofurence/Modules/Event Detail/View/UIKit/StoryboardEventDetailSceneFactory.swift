//
//  StoryboardEventDetailSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct StoryboardEventDetailSceneFactory: EventDetailSceneFactory {

    private let storyboard = UIStoryboard(name: "EventDetail", bundle: .main)

    func makeEventDetailScene() -> UIViewController & EventDetailScene {
        return storyboard.instantiate(EventDetailViewController.self)
    }

}
