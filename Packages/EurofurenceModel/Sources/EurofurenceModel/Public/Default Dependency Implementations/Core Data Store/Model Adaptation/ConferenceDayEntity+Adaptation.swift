import Foundation

extension ConferenceDayEntity: EntityAdapting {

    typealias AdaptedType = ConferenceDayCharacteristics

    static func makeIdentifyingPredicate(for model: ConferenceDayCharacteristics) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.identifier)
    }

    func asAdaptedType() -> ConferenceDayCharacteristics {
        guard let identifier = identifier, let date = date else {
            abandonDueToInconsistentState()
        }
        
        return ConferenceDayCharacteristics(identifier: identifier, date: date)
    }

    func consumeAttributes(from value: ConferenceDayCharacteristics) {
        identifier = value.identifier
        date = value.date
    }

}
