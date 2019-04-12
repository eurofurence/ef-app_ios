import Foundation

public extension BinaryInteger {

    static var random: Self {
        return Self(arc4random())
    }

    static func random(upperLimit: UInt32) -> Self {
        return Self(arc4random_uniform(upperLimit))
    }

}

extension Int: RandomValueProviding, RandomRangedValueProviding { }
