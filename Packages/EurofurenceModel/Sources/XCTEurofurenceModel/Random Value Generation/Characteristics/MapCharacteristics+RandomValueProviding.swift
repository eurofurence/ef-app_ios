import EurofurenceModel
import Foundation
import TestUtilities

extension MapCharacteristics: RandomValueProviding {
    
    public static var random: MapCharacteristics {
        MapCharacteristics(
            identifier: .random,
            imageIdentifier: .random,
            mapDescription: .random,
            order: .random,
            entries: .random
        )
    }
    
}

extension MapCharacteristics.Entry: RandomValueProviding {
    
    public static var random: MapCharacteristics.Entry {
        MapCharacteristics.Entry(identifier: .random, x: .random, y: .random, tapRadius: .random, links: .random)
    }
    
}

extension MapCharacteristics.Entry.Link: RandomValueProviding {
    
    public static var random: MapCharacteristics.Entry.Link {
        MapCharacteristics.Entry.Link(type: .random, name: .random, target: .random)
    }
    
}

extension MapCharacteristics.Entry.Link.FragmentType: RandomValueProviding {
    
    public static var random: MapCharacteristics.Entry.Link.FragmentType {
        let cases: [MapCharacteristics.Entry.Link.FragmentType] = [.conferenceRoom, .mapEntry, .dealerDetail]
        return cases.randomElement().element
    }
    
}
