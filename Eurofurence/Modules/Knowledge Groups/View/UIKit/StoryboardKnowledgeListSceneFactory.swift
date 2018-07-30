//
//  StoryboardKnowledgeListSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct StoryboardKnowledgeListSceneFactory: KnowledgeListSceneFactory {

    private let storyboard = UIStoryboard(name: "KnowledgeList", bundle: .main)

    func makeKnowledgeListScene() -> UIViewController & KnowledgeListScene {
        return storyboard.instantiate(KnowledgeListViewController.self)
    }

}
