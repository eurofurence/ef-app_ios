import EurofurenceModel
import Foundation
import TestUtilities

extension TrackCharacteristics: RandomValueProviding {
    
    public static var random: TrackCharacteristics {
        return TrackCharacteristics(identifier: .random, name: .random)
    }
    
}
