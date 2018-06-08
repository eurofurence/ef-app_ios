//
//  KnowledgeGroupEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension KnowledgeGroupEntity: EntityAdapting {

    typealias AdaptedType = APIKnowledgeGroup

    func asAdaptedType() -> APIKnowledgeGroup {
        return APIKnowledgeGroup(identifier: identifier!,
                                 order: Int(order),
                                 groupName: groupName!,
                                 groupDescription: groupDescription!)
    }

}
