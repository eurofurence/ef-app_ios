import EurofurenceModel
import Foundation
import TestUtilities

extension Room: RandomValueProviding {

    public static var random: Room {
        return Room(name: .random)
    }

}
