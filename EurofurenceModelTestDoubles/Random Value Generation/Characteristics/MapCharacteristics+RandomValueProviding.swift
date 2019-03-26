//
//  MapCharacteristics+RandomValueProviding.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 19/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import TestUtilities

extension MapCharacteristics: RandomValueProviding {
    
    public static var random: MapCharacteristics {
        return MapCharacteristics(identifier: .random, imageIdentifier: .random, mapDescription: .random, entries: .random)
    }
    
}

extension MapCharacteristics.Entry: RandomValueProviding {
    
    public static var random: MapCharacteristics.Entry {
        return MapCharacteristics.Entry(identifier: .random, x: .random, y: .random, tapRadius: .random, links: .random)
    }
    
}

extension MapCharacteristics.Entry.Link: RandomValueProviding {
    
    public static var random: MapCharacteristics.Entry.Link {
        return MapCharacteristics.Entry.Link(type: .random, name: .random, target: .random)
    }
    
}

extension MapCharacteristics.Entry.Link.FragmentType: RandomValueProviding {
    
    public static var random: MapCharacteristics.Entry.Link.FragmentType {
        let cases: [MapCharacteristics.Entry.Link.FragmentType] = [.conferenceRoom, .mapEntry, .dealerDetail]
        return cases.randomElement().element
    }
    
}
