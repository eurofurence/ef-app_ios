import Foundation

public extension BinaryInteger {

    static var random: Self {
        return Self(UInt32.random(upperLimit: .max))
    }

    static func random(upperLimit: UInt32) -> Self {
        return Self(UInt32.random(in: 0..<upperLimit))
    }

}

extension Int: RandomValueProviding, RandomRangedValueProviding { }
