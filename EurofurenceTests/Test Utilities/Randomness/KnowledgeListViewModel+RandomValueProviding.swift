//
//  KnowledgeListViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Darwin
@testable import Eurofurence
import UIKit.UIImage

extension KnowledgeListViewModel: RandomValueProviding {
    
    static var random: KnowledgeListViewModel {
        return KnowledgeListViewModel(knowledgeGroups: .random)
    }
    
}

extension KnowledgeGroupViewModel: RandomValueProviding {
    
    static var random: KnowledgeGroupViewModel {
        return KnowledgeGroupViewModel(title: .random,
                                       icon: UIImage(),
                                       groupDescription: .random,
                                       knowledgeEntries: .random)
    }
    
}

extension KnowledgeEntryViewModel: RandomValueProviding {
    
    static var random: KnowledgeEntryViewModel {
        return KnowledgeEntryViewModel(title: .random)
    }
    
}
