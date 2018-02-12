//
//  KnowledgeInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol KnowledgeInteractor {

    func prepareViewModel(completionHandler: @escaping (KnowledgeBaseViewModel) -> Void)

}
