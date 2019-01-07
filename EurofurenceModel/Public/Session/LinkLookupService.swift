//
//  LinkLookupService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol LinkLookupService {

    func lookupContent(for link: Link) -> LinkContentLookupResult?
    func setExternalContentHandler(_ externalContentHandler: ExternalContentHandler)

}

public enum LinkContentLookupResult: Equatable {

    case web(URL)
    case externalURL(URL)

    public static func ==(lhs: LinkContentLookupResult, rhs: LinkContentLookupResult) -> Bool {
        switch (lhs, rhs) {
        case (.web(let l), .web(let r)):
            return l == r

        case (.externalURL(let l), .externalURL(let r)):
            return l == r

        default:
            return false
        }
    }
}
