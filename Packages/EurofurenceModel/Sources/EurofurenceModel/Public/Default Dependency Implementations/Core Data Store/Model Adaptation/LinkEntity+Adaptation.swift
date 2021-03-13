import Foundation

extension LinkEntity: EntityAdapting {

    typealias AdaptedType = LinkCharacteristics

    static func makeIdentifyingPredicate(for model: LinkCharacteristics) -> NSPredicate {
        return NSPredicate(value: false)
    }

    func asAdaptedType() -> LinkCharacteristics {
        guard let name = name,
              let fragmentType = LinkCharacteristics.FragmentType(rawValue: Int(fragmentType)),
              let target = target else {
            abandonDueToInconsistentState()
        }
        
        return LinkCharacteristics(name: name, fragmentType: fragmentType, target: target)
    }

    func consumeAttributes(from value: LinkCharacteristics) {
        name = value.name
        target = value.target
        fragmentType = Int16(Float(value.fragmentType.rawValue))
    }

}
