//
//  KnowledgeGroupEntriesViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

protocol KnowledgeGroupEntriesViewModel {

    var title: String { get }
    var numberOfEntries: Int { get }

    func knowledgeEntry(at index: Int) -> KnowledgeListEntryViewModel
    func identifierForKnowledgeEntry(at index: Int) -> KnowledgeEntry.Identifier

}
