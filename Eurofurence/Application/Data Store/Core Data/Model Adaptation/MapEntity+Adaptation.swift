//
//  MapEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension MapEntity: EntityAdapting {

    typealias AdaptedType = APIMap

    func asAdaptedType() -> APIMap {
        let entries = ((self.entries as? Set<MapEntryEntity>) ?? Set())
        return APIMap(identifier: identifier!,
                      imageIdentifier: imageIdentifier!,
                      mapDescription: mapDescription!,
                      entries: entries.map({ $0.asAdaptedType() }))
    }

}

extension MapEntryEntity: EntityAdapting {

    typealias AdaptedType = APIMap.Entry

    func asAdaptedType() -> APIMap.Entry {
        let links = ((self.links as? Set<MapEntryLinkEntity>) ?? Set())
        return APIMap.Entry(x: Int(x),
                            y: Int(y),
                            tapRadius: Int(tapRadius),
                            links: links.map({ $0.asAdaptedType() }))
    }

}

extension MapEntryLinkEntity: EntityAdapting {

    typealias AdaptedType = APIMap.Entry.Link

    func asAdaptedType() -> APIMap.Entry.Link {
        return APIMap.Entry.Link(type: APIMap.Entry.Link.FragmentType(rawValue: Int(type))!,
                                 name: name,
                                 target: target!)
    }

}
