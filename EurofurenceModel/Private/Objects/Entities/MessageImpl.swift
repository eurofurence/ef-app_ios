//
//  MessageImpl.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 18/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

struct MessageImpl: Message {
    
    struct ReadEvent {
        var message: Message
    }
    
    private let eventBus: EventBus

    var identifier: String
    var authorName: String
    var receivedDateTime: Date
    var subject: String
    var contents: String
    var isRead: Bool

    init(eventBus: EventBus, characteristics: MessageCharacteristics) {
        self.eventBus = eventBus
        
        self.identifier = characteristics.identifier
        self.authorName = characteristics.authorName
        self.receivedDateTime = characteristics.receivedDateTime
        self.subject = characteristics.subject
        self.contents = characteristics.contents
        self.isRead = characteristics.isRead
    }
    
    func markAsRead() {
        eventBus.post(ReadEvent(message: self))
    }

}
