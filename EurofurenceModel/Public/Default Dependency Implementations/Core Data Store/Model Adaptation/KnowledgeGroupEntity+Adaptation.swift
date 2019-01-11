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

    static func makeIdentifyingPredicate(for model: APIKnowledgeGroup) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.identifier)
    }

    func asAdaptedType() -> APIKnowledgeGroup {
        return APIKnowledgeGroup(identifier: identifier!,
                                 order: Int(order),
                                 groupName: groupName!,
                                 groupDescription: groupDescription!,
                                 fontAwesomeCharacterAddress: fontAwesomeCharacterAddress ?? "")
    }

    func consumeAttributes(from value: APIKnowledgeGroup) {
        identifier = value.identifier
        order = Int64(value.order)
        groupName = value.groupName
        groupDescription = value.groupDescription
        fontAwesomeCharacterAddress = value.fontAwesomeCharacterAddress
    }

}
