import Foundation

extension RoomEntity: EntityAdapting {

    typealias AdaptedType = RoomCharacteristics

    static func makeIdentifyingPredicate(for model: RoomCharacteristics) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.identifier)
    }

    func asAdaptedType() -> RoomCharacteristics {
        return RoomCharacteristics(identifier: identifier!, name: name!)
    }

    func consumeAttributes(from value: RoomCharacteristics) {
        identifier = value.identifier
        name = value.name
    }

}
