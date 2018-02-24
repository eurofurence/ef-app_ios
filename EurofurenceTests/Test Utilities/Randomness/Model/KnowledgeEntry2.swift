//
//  KnowledgeEntry2.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

extension KnowledgeEntry2: RandomValueProviding {
    
    static var random: KnowledgeEntry2 {
        return KnowledgeEntry2(title: .random)
    }
    
}
