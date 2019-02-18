//
//  MessageEntity.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 18/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

struct MessageEntity: Message {

    var identifier: String
    var authorName: String
    var receivedDateTime: Date
    var subject: String
    var contents: String
    var isRead: Bool

    init(identifier: String, authorName: String, receivedDateTime: Date, subject: String, contents: String, isRead: Bool) {
        self.identifier = identifier
        self.authorName = authorName
        self.receivedDateTime = receivedDateTime
        self.subject = subject
        self.contents = contents
        self.isRead = isRead
    }

}

extension MessageEntity {

    static func fromCharacteristics(_ characteristics: [MessageCharacteristics]) -> [MessageEntity] {
        return characteristics.map(fromCharacteristic)
    }

    static func fromCharacteristic(_ characteristic: MessageCharacteristics) -> MessageEntity {
        return MessageEntity(identifier: characteristic.identifier,
                             authorName: characteristic.authorName,
                             receivedDateTime: characteristic.receivedDateTime,
                             subject: characteristic.subject,
                             contents: characteristic.contents,
                             isRead: characteristic.isRead)
    }

}
