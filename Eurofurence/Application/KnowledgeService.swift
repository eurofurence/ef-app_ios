//
//  KnowledgeService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol KnowledgeService {

    func fetchKnowledgeGroups(completionHandler: @escaping ([KnowledgeGroup2]) -> Void)

}
