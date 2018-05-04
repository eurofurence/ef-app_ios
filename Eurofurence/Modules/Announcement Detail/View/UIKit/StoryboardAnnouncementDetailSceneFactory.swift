//
//  StoryboardAnnouncementDetailSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct StoryboardAnnouncementDetailSceneFactory: AnnouncementDetailSceneFactory {

    private let storyboard = UIStoryboard(name: "AnnouncementDetail", bundle: .main)

    func makeAnnouncementDetailScene() -> UIViewController & AnnouncementDetailScene {
        return storyboard.instantiate(AnnouncementDetailViewController.self)
    }

}
