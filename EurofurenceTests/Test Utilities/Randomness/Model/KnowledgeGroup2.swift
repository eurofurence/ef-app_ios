//
//  KnowledgeGroup2.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation
import RandomDataGeneration

extension KnowledgeGroup2: RandomValueProviding {
    
    public static var random: KnowledgeGroup2 {
        return KnowledgeGroup2(identifier: .random,
                               title: .random,
                               groupDescription: .random,
                               fontAwesomeCharacterAddress: .random,
                               order: .random,
                               entries: .random)
    }
    
}

extension KnowledgeGroup2.Identifier: RandomValueProviding {
    
    public static var random: KnowledgeGroup2.Identifier {
        return KnowledgeGroup2.Identifier(.random)
    }
    
}
