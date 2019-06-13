import Foundation

protocol EntityAdapting {

    associatedtype AdaptedType

    static func makeIdentifyingPredicate(for model: AdaptedType) -> NSPredicate
    func asAdaptedType() -> AdaptedType
    func consumeAttributes(from value: AdaptedType)

}
