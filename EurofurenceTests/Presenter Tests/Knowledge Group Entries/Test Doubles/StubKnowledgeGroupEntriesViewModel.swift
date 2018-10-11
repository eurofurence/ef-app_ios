//
//  StubKnowledgeGroupEntriesViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import Foundation
import RandomDataGeneration

struct StubKnowledgeGroupEntriesViewModel: KnowledgeGroupEntriesViewModel {

    var title: String

    var numberOfEntries: Int {
        return entries.count
    }

    func knowledgeEntry(at index: Int) -> KnowledgeListEntryViewModel {
        return entries[index]
    }

    func identifierForKnowledgeEntry(at index: Int) -> KnowledgeEntry.Identifier {
        return KnowledgeEntry.Identifier("\(index) - \(entries[index].title)")
    }

    var entries: [KnowledgeListEntryViewModel]

}

extension StubKnowledgeGroupEntriesViewModel: RandomValueProviding {

    static var random: StubKnowledgeGroupEntriesViewModel {
        return StubKnowledgeGroupEntriesViewModel(title: .random, entries: .random)
    }

}
