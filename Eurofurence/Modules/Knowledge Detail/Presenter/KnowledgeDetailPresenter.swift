//
//  KnowledgeDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

struct KnowledgeDetailPresenter {

    init(knowledgeDetailScene: KnowledgeDetailScene, knowledgeEntry: KnowledgeEntry2) {
        knowledgeDetailScene.setKnowledgeDetailTitle(knowledgeEntry.title)
    }

}
