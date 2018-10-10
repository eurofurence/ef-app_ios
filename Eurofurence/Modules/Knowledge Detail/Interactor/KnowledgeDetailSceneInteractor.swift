//
//  KnowledgeDetailSceneInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

protocol KnowledgeDetailSceneInteractor {

    func makeViewModel(for identifier: KnowledgeEntry.Identifier, completionHandler: @escaping (KnowledgeEntryDetailViewModel) -> Void)

}
