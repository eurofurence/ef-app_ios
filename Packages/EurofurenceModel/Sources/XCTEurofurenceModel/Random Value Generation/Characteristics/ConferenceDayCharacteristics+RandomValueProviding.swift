import EurofurenceModel
import Foundation
import TestUtilities

extension ConferenceDayCharacteristics: RandomValueProviding {
    
    public static var random: ConferenceDayCharacteristics {
        let randomDate = Date.random
        var components = Calendar.current.dateComponents(in: .current, from: randomDate)
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        
        let normalizedDate = components.date.unsafelyUnwrapped
        
        return ConferenceDayCharacteristics(identifier: .random, date: normalizedDate)
    }
    
}
