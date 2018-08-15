//
//  KnowledgeGroupEntriesScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol KnowledgeGroupEntriesScene {

    func setDelegate(_ delegate: KnowledgeGroupEntriesSceneDelegate)
    func setKnowledgeGroupTitle(_ title: String)
    func bind(numberOfEntries: Int, using binder: KnowledgeGroupEntriesBinder)

}

protocol KnowledgeGroupEntriesSceneDelegate {

    func knowledgeGroupEntriesSceneDidLoad()
    func knowledgeGroupEntriesSceneDidSelectEntry(at index: Int)

}
