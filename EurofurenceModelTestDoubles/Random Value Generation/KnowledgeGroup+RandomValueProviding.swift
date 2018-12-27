//
//  KnowledgeGroup.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import RandomDataGeneration

extension KnowledgeGroup: RandomValueProviding {

    public static var random: KnowledgeGroup {
        return KnowledgeGroup(identifier: .random,
                              title: .random,
                              groupDescription: .random,
                              fontAwesomeCharacterAddress: .random,
                              order: .random,
                              entries: .random)
    }

}

extension KnowledgeGroup.Identifier: RandomValueProviding {

    public static var random: KnowledgeGroup.Identifier {
        return KnowledgeGroup.Identifier(.random)
    }

}
