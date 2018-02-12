//
//  KnowledgeListScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol KnowledgeListScene {

    func setDelegate(_ delegate: KnowledgeListSceneDelegate)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func prepareToDisplayKnowledgeGroups(entriesPerGroup: [Int])

}
