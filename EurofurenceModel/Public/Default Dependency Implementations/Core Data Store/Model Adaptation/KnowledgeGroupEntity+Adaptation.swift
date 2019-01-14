//
//  KnowledgeGroupEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension KnowledgeGroupEntity: EntityAdapting {

    typealias AdaptedType = KnowledgeGroupCharacteristics

    static func makeIdentifyingPredicate(for model: KnowledgeGroupCharacteristics) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.identifier)
    }

    func asAdaptedType() -> KnowledgeGroupCharacteristics {
        return KnowledgeGroupCharacteristics(identifier: identifier!,
                                 order: Int(order),
                                 groupName: groupName!,
                                 groupDescription: groupDescription!,
                                 fontAwesomeCharacterAddress: fontAwesomeCharacterAddress ?? "")
    }

    func consumeAttributes(from value: KnowledgeGroupCharacteristics) {
        identifier = value.identifier
        order = Int64(value.order)
        groupName = value.groupName
        groupDescription = value.groupDescription
        fontAwesomeCharacterAddress = value.fontAwesomeCharacterAddress
    }

}
