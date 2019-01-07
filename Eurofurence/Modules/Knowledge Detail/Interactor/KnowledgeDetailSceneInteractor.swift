//
//  KnowledgeDetailSceneInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

protocol KnowledgeDetailSceneInteractor {

    func makeViewModel(for identifier: KnowledgeEntryIdentifier, completionHandler: @escaping (KnowledgeEntryDetailViewModel) -> Void)

}
