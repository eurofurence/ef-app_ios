//
//  StubLinkRouter.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel

class StubLinkRouter: LinkLookupService {

    var stubbedLinkActions = [Link: LinkContentLookupResult]()
    func lookupContent(for link: Link) -> LinkContentLookupResult? {
        return stubbedLinkActions[link]
    }

}
