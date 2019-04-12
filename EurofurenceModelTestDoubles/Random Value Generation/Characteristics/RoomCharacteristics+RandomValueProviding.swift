import EurofurenceModel
import Foundation
import TestUtilities

extension RoomCharacteristics: RandomValueProviding {
    
    public static var random: RoomCharacteristics {
        return RoomCharacteristics(identifier: .random, name: .random)
    }
    
}
