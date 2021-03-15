import EurofurenceModel
import Foundation
import TestUtilities

extension AnnouncementCharacteristics: RandomValueProviding {
    
    public static var random: AnnouncementCharacteristics {
        return AnnouncementCharacteristics(identifier: .random,
                                           title: .random,
                                           content: .random,
                                           lastChangedDateTime: .random,
                                           imageIdentifier: .random)
    }
    
}
