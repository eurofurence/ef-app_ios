//
//  KnowledgeGroup2.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

extension KnowledgeGroup2: RandomValueProviding {
    
    static var random: KnowledgeGroup2 {
        return KnowledgeGroup2(title: .random, groupDescription: .random, order: .random, entries: .random)
    }
    
}
