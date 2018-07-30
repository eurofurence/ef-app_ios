//
//  StubKnowledgeGroupEntriesViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 30/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct StubKnowledgeGroupEntriesViewModel: KnowledgeGroupEntriesViewModel {
    
    var numberOfEntries: Int
    
}

extension StubKnowledgeGroupEntriesViewModel: RandomValueProviding {
    
    static var random: StubKnowledgeGroupEntriesViewModel {
        return StubKnowledgeGroupEntriesViewModel(numberOfEntries: .random)
    }
    
}
