//
//  KnowledgeDetailScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol KnowledgeDetailScene {

    func setKnowledgeDetailSceneDelegate(_ delegate: KnowledgeDetailSceneDelegate)
    func setKnowledgeDetailTitle(_ title: String)
    func setAttributedKnowledgeEntryContents(_ contents: NSAttributedString)

}

protocol KnowledgeDetailSceneDelegate {

    func knowledgeDetailSceneDidLoad()

}
