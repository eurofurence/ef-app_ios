//
//  KnowledgeGroupEntriesModuleDelegate.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

protocol KnowledgeGroupEntriesModuleDelegate {

    func knowledgeGroupEntriesModuleDidSelectKnowledgeEntry(identifier: KnowledgeEntry.Identifier)

}
