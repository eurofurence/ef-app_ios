//
//  KnowledgeGroupsInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol KnowledgeGroupsInteractor {

    func prepareViewModel(completionHandler: @escaping (KnowledgeGroupsListViewModel) -> Void)
    func fetchEntry(inGroup group: Int, index: Int, completionHandler: @escaping (KnowledgeEntry2) -> Void)

}
