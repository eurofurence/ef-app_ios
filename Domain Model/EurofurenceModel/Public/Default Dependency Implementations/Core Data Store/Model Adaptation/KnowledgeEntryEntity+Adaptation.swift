import Foundation

extension KnowledgeEntryEntity: EntityAdapting {

    typealias AdaptedType = KnowledgeEntryCharacteristics

    static func makeIdentifyingPredicate(for model: KnowledgeEntryCharacteristics) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.identifier)
    }

    func asAdaptedType() -> KnowledgeEntryCharacteristics {
        let links = Array((self.links as? Set<LinkEntity>) ?? Set<LinkEntity>())
        guard let identifier = identifier,
              let groupIdentifier = groupIdentifier,
              let title = title,
              let text = text else {
            abandonDueToInconsistentState()
        }

        return KnowledgeEntryCharacteristics(identifier: identifier,
                                             groupIdentifier: groupIdentifier,
                                             title: title,
                                             order: Int(order),
                                             text: text,
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
