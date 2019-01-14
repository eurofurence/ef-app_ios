//
//  MapEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension MapEntity: EntityAdapting {

    typealias AdaptedType = MapCharacteristics

    static func makeIdentifyingPredicate(for model: MapCharacteristics) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.identifier)
    }

    func asAdaptedType() -> MapCharacteristics {
        let entries = ((self.entries as? Set<MapEntryEntity>) ?? Set())
        return MapCharacteristics(identifier: identifier!,
                      imageIdentifier: imageIdentifier!,
                      mapDescription: mapDescription!,
                      entries: entries.map({ $0.asAdaptedType() }))
    }

    func consumeAttributes(from value: MapCharacteristics) {
        identifier = value.identifier
        imageIdentifier = value.imageIdentifier
        mapDescription = value.mapDescription
    }

}

extension MapEntryEntity: EntityAdapting {

    typealias AdaptedType = MapCharacteristics.Entry

    static func makeIdentifyingPredicate(for model: MapCharacteristics.Entry) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.identifier)
    }

    func asAdaptedType() -> MapCharacteristics.Entry {
        let links = ((self.links as? Set<MapEntryLinkEntity>) ?? Set())
        return MapCharacteristics.Entry(identifier: identifier.or(""),
                            x: Int(x),
                            y: Int(y),
                            tapRadius: Int(tapRadius),
                            links: links.map({ $0.asAdaptedType() }))
    }

    func consumeAttributes(from value: MapCharacteristics.Entry) {
        identifier = value.identifier
        x = Int64(value.x)
        y = Int64(value.y)
        tapRadius = Int64(value.tapRadius)
    }

}

extension MapEntryLinkEntity: EntityAdapting {

    typealias AdaptedType = MapCharacteristics.Entry.Link

    static func makeIdentifyingPredicate(for model: MapCharacteristics.Entry.Link) -> NSPredicate {
        return NSPredicate(value: false)
    }

    func asAdaptedType() -> MapCharacteristics.Entry.Link {
        return MapCharacteristics.Entry.Link(type: MapCharacteristics.Entry.Link.FragmentType(rawValue: Int(type))!,
                                 name: name,
                                 target: target!)
    }

    func consumeAttributes(from value: MapCharacteristics.Entry.Link) {
        type = Int16(value.type.rawValue)
        name = value.name
        target = value.target
    }

}
