//
//  ConcreteContentLinksService.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 20/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

struct ConcreteContentLinksService: ContentLinksService {

    var urlHandler: URLHandler

    func setExternalContentHandler(_ externalContentHandler: ExternalContentHandler) {
        urlHandler.externalContentHandler = externalContentHandler
    }

    func lookupContent(for link: Link) -> LinkContentLookupResult? {
        guard let urlString = link.contents as? String, let url = URL(string: urlString) else { return nil }

        if let scheme = url.scheme, scheme == "https" || scheme == "http" {
            return .web(url)
        }

        return .externalURL(url)
    }

}
