import Foundation

extension AnnouncementEntity: EntityAdapting {

    typealias AdaptedType = AnnouncementCharacteristics

    static func makeIdentifyingPredicate(for model: AnnouncementCharacteristics) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.identifier)
    }

    func asAdaptedType() -> AnnouncementCharacteristics {
        return AnnouncementCharacteristics(identifier: identifier!,
                               title: title!,
                               content: content!,
                               lastChangedDateTime: lastChangedDateTime! as Date,
                               imageIdentifier: imageIdentifier)
    }

    func consumeAttributes(from value: AnnouncementCharacteristics) {
        identifier = value.identifier
        title = value.title
        content = value.content
        lastChangedDateTime = value.lastChangedDateTime
        imageIdentifier = value.imageIdentifier
    }

}
