//
//  APIKnowledgeGroup.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct APIKnowledgeGroup: Equatable {

    var identifier: String
    var order: Int
    var groupName: String
    var groupDescription: String

    static func ==(lhs: APIKnowledgeGroup, rhs: APIKnowledgeGroup) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.order == rhs.order && lhs.groupName == rhs.groupName && lhs.groupDescription == rhs.groupDescription
    }

}
