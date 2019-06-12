import Foundation

extension ImageModelEntity: EntityAdapting {

    typealias AdaptedType = ImageCharacteristics

    static func makeIdentifyingPredicate(for model: ImageCharacteristics) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.identifier)
    }

    func asAdaptedType() -> ImageCharacteristics {
        return ImageCharacteristics(identifier: identifier!,
                                    internalReference: internalReference!,
                                    contentHashSha1: contentHashSha1!)
    }

    func consumeAttributes(from value: ImageCharacteristics) {
        identifier = value.identifier
        internalReference = value.internalReference
        contentHashSha1 = value.contentHashSha1
    }

}
