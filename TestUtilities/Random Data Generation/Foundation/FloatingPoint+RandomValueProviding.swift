import Foundation

public extension BinaryFloatingPoint {

    static var random: Self {
        return Self(arc4random())
    }

    static func random(upperLimit: UInt32) -> Self {
        return Self(arc4random_uniform(upperLimit))
    }

}

extension Double: RandomValueProviding, RandomRangedValueProviding {}
extension Float: RandomValueProviding, RandomRangedValueProviding {}
