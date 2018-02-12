//
//  KnowledgeListBinder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol KnowledgeListBinder {

    func bind(_ header: KnowledgeGroupHeaderScene, toGroupAt index: Int)
    func bind(_ entry: KnowledgeGroupEntryScene, toEntryInGroup groupIndex: Int, at entryIndex: Int)

}
