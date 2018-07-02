//
//  StoryboardAnnouncementsSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct StoryboardAnnouncementsSceneFactory: AnnouncementsSceneFactory {

    private let storyboard = UIStoryboard(name: "Announcements", bundle: .main)

    func makeAnnouncementsScene() -> UIViewController & AnnouncementsScene {
        return storyboard.instantiate(AnnouncementsViewController.self)
    }

}
