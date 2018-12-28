//
//  URLHandler.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

class URLHandler: EventConsumer {

    var externalContentHandler: ExternalContentHandler?

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

}
