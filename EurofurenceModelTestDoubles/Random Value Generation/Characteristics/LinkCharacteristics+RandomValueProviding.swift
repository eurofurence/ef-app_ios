import EurofurenceModel
import Foundation
import TestUtilities

extension LinkCharacteristics: RandomValueProviding {
    
    public static var random: LinkCharacteristics {
        return LinkCharacteristics(name: .random, fragmentType: .random, target: .random)
    }
    
}

extension LinkCharacteristics.FragmentType: RandomValueProviding {
    
    public static var random: LinkCharacteristics.FragmentType {
        return .WebExternal
    }
    
}
