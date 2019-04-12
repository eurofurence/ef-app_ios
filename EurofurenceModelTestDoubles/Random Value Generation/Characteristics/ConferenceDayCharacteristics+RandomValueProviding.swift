import EurofurenceModel
import Foundation
import TestUtilities

extension ConferenceDayCharacteristics: RandomValueProviding {
    
    public static var random: ConferenceDayCharacteristics {
        return ConferenceDayCharacteristics(identifier: .random, date: .random)
    }
    
}
