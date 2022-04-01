import Foundation

public extension BinaryFloatingPoint {

    static var random: Self {
        return Self(UInt32.random)
    }

    static func random(upperLimit: UInt32) -> Self {
        return Self(UInt32.random(in: 0...upperLimit))
    }

}

extension Double: RandomValueProviding, RandomRangedValueProviding {}
extension Float: RandomValueProviding, RandomRangedValueProviding {}
