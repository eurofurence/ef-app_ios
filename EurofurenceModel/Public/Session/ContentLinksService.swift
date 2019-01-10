//
//  ContentLinksService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol ContentLinksService {

    func lookupContent(for link: Link) -> LinkContentLookupResult?
    func setExternalContentHandler(_ externalContentHandler: ExternalContentHandler)

}

public enum LinkContentLookupResult: Equatable {

    case web(URL)
    case externalURL(URL)

}
