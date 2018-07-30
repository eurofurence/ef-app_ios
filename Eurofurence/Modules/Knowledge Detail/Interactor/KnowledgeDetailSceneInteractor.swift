//
//  KnowledgeDetailSceneInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol KnowledgeDetailSceneInteractor {

    func makeViewModel(for identifier: KnowledgeEntry2.Identifier, completionHandler: @escaping (KnowledgeEntryDetailViewModel) -> Void)

}
