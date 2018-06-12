//
//  StoryboardScheduleSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct StoryboardScheduleSceneFactory: ScheduleSceneFactory {

    private let storyboard = UIStoryboard(name: "Schedule", bundle: .main)

    func makeEventsScene() -> UIViewController & ScheduleScene {
        return storyboard.instantiate(ScheduleViewController.self)
    }

}
