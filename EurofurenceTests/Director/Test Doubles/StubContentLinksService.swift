//
//  StubContentLinksService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel

class StubContentLinksService: ContentLinksService {

    var stubbedLinkActions = [Link: LinkContentLookupResult]()
    func lookupContent(for link: Link) -> LinkContentLookupResult? {
        return stubbedLinkActions[link]
    }

    func setExternalContentHandler(_ externalContentHandler: ExternalContentHandler) {

    }

}
