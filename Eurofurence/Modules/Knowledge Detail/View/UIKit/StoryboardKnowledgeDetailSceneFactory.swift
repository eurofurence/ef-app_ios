//
//  StoryboardKnowledgeDetailSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIStoryboard
import UIKit.UIViewController

struct StoryboardKnowledgeDetailSceneFactory: KnowledgeDetailSceneFactory {

    private let storyboard = UIStoryboard(name: "KnowledgeDetail", bundle: .main)

    func makeKnowledgeDetailScene() -> UIViewController & KnowledgeDetailScene {
        return storyboard.instantiate(KnowledgeDetailViewController.self)
    }

}
