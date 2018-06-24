//
//  URLHandler.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class URLHandler: EventConsumer {

    var externalContentHandler: ExternalContentHandler?

    private let urlOpener: URLOpener

    init(eventBus: EventBus, urlOpener: URLOpener) {
        self.urlOpener = urlOpener
        eventBus.subscribe(consumer: self)
    }

    func consume(event: DomainEvent.OpenURL) {
        if urlOpener.canOpen(event.preferredURL) {
            urlOpener.open(event.preferredURL)
        } else if let backupURL = event.backupURL {
            externalContentHandler?.handleExternalContent(url: backupURL)
        }
    }

}
