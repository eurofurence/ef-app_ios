//
//  KnowledgeEntry.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import TestUtilities

extension KnowledgeEntry: RandomValueProviding {

    public static var random: KnowledgeEntry {
        return KnowledgeEntry(identifier: .random, title: .random, order: .random, contents: .random, links: .random)
    }

}
