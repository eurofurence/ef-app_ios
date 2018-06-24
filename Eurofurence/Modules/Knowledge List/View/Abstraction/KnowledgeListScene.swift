//
//  KnowledgeListScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation.NSIndexPath

protocol KnowledgeListScene {

    func setDelegate(_ delegate: KnowledgeListSceneDelegate)
    func setKnowledgeListTitle(_ title: String)
    func setKnowledgeListShortTitle(_ shortTitle: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func prepareToDisplayKnowledgeGroups(entriesPerGroup: [Int], binder: KnowledgeListBinder)
    func deselectKnowledgeEntry(at indexPath: IndexPath)

}
