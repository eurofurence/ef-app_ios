import Foundation

extension RoomEntity: EntityAdapting {

    typealias AdaptedType = RoomCharacteristics

    static func makeIdentifyingPredicate(for model: RoomCharacteristics) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.identifier)
    }

    func asAdaptedType() -> RoomCharacteristics {
        guard let identifier = identifier, let name = name else {
            abandonDueToInconsistentState()
        }
        
        return RoomCharacteristics(identifier: identifier, name: name)
    }

    func consumeAttributes(from value: RoomCharacteristics) {
        identifier = value.identifier
        name = value.name
    }

}
