//
//  ConcreteContentLinksService.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 20/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

class ConcreteContentLinksService: ContentLinksService, EventConsumer {

    private var externalContentHandler: ExternalContentHandler?
    private let urlOpener: URLOpener?

    init(eventBus: EventBus, urlOpener: URLOpener?) {
        self.urlOpener = urlOpener
        eventBus.subscribe(consumer: self)
    }

    func consume(event: DomainEvent.OpenURL) {
        let url = event.url

        if let urlOpener = urlOpener, urlOpener.canOpen(url) {
            urlOpener.open(url)
        } else {
            externalContentHandler?.handleExternalContent(url: url)
        }
    }

    func setExternalContentHandler(_ externalContentHandler: ExternalContentHandler) {
        self.externalContentHandler = externalContentHandler
    }

    func lookupContent(for link: Link) -> LinkContentLookupResult? {
        guard let urlString = link.contents as? String, let url = URL(string: urlString) else { return nil }

        if let scheme = url.scheme, scheme == "https" || scheme == "http" {
            return .web(url)
        }

        return .externalURL(url)
    }

}
