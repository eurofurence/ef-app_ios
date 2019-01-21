//
//  KnowledgeEntryEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension KnowledgeEntryEntity: EntityAdapting {

    typealias AdaptedType = KnowledgeEntryCharacteristics

    static func makeIdentifyingPredicate(for model: KnowledgeEntryCharacteristics) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.identifier)
    }

    func asAdaptedType() -> KnowledgeEntryCharacteristics {
        let links = Array((self.links as? Set<LinkEntity>) ?? Set<LinkEntity>())

        return KnowledgeEntryCharacteristics(identifier: identifier!,
                                 groupIdentifier: groupIdentifier!,
                                 title: title!,
                                 order: Int(order),
                                 text: text!,
                                 links: links.map({ $0.asAdaptedType() }).sorted(),
                                 imageIdentifiers: imageIdentifiers.defaultingTo(.empty))
    }

    func consumeAttributes(from value: KnowledgeEntryCharacteristics) {
        identifier = value.identifier
        title = value.title
        text = value.text
        groupIdentifier = value.groupIdentifier
        order = Int64(value.order)
        imageIdentifiers = value.imageIdentifiers
    }

}
