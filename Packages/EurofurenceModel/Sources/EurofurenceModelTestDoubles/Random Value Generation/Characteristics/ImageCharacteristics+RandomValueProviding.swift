import EurofurenceModel
import Foundation
import TestUtilities

extension ImageCharacteristics: RandomValueProviding {
    
    public static var random: ImageCharacteristics {
        return ImageCharacteristics(identifier: .random, internalReference: .random, contentHashSha1: .random)
    }
    
}
