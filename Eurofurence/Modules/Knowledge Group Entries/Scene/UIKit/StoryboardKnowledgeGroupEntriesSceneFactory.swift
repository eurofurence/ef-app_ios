//
//  StoryboardKnowledgeGroupEntriesSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct StoryboardKnowledgeGroupEntriesSceneFactory: KnowledgeGroupEntriesSceneFactory {

    private let storyboard = UIStoryboard(name: "KnowledgeGroupEntries", bundle: .main)

    func makeKnowledgeGroupEntriesScene() -> UIViewController & KnowledgeGroupEntriesScene {
        return storyboard.instantiate(KnowledgeGroupEntriesViewController.self)
    }

}
