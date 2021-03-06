import Foundation

extension FavouriteEventEntity: EntityAdapting {

    typealias AdaptedType = EventIdentifier

    static func makeIdentifyingPredicate(for model: EventIdentifier) -> NSPredicate {
        return NSPredicate(format: "eventIdentifier == %@", model.rawValue)
    }

    func asAdaptedType() -> EventIdentifier {
        guard let eventIdentifier = eventIdentifier else {
            abandonDueToInconsistentState()
        }
        
        return EventIdentifier(eventIdentifier)
    }

    func consumeAttributes(from value: EventIdentifier) {
        eventIdentifier = value.rawValue
    }

}
