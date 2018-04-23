//
//  StoryboardEventsSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct StoryboardEventsSceneFactory: EventsSceneFactory {

    private let storyboard = UIStoryboard(name: "Events", bundle: .main)

    func makeEventsScene() -> UIViewController & EventsScene {
        return storyboard.instantiate(EventsViewController.self)
    }

}
