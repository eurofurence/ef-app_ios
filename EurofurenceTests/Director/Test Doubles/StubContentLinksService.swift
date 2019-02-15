//
//  StubContentLinksService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel

class StubContentLinksService: ContentLinksService {

    private var stubbedLinkActions = [String: LinkContentLookupResult]()

    func stubContent(_ content: LinkContentLookupResult, for link: Link) {
        stubbedLinkActions[link.name] = content
    }

    func lookupContent(for link: Link) -> LinkContentLookupResult? {
        return stubbedLinkActions[link.name]
    }

    func setExternalContentHandler(_ externalContentHandler: ExternalContentHandler) {

    }

}
