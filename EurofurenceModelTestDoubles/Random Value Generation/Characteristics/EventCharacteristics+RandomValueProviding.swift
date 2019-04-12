import EurofurenceModel
import Foundation
import TestUtilities

extension EventCharacteristics: RandomValueProviding {
    
    public static var random: EventCharacteristics {
        return EventCharacteristics(identifier: .random,
                                    roomIdentifier: .random,
                                    trackIdentifier: .random,
                                    dayIdentifier: .random,
                                    startDateTime: .random,
                                    endDateTime: .random,
                                    title: .random,
                                    subtitle: .random,
                                    abstract: .random,
                                    panelHosts: .random,
                                    eventDescription: .random,
                                    posterImageId: .random,
                                    bannerImageId: .random,
                                    tags: .random)
    }
    
}
