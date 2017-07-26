//
//  V2APIPrivateMessagesResponse.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct V2APIPrivateMessagesResponse: APIPrivateMessagesResponse {

    var messages: [APIPrivateMessage]

    init?(json: [[String : Any]]) {
        messages = [V2APIPrivateMessage]()

        for jsonMessage in json {
            if let message = V2APIPrivateMessage(jsonDictionary: jsonMessage) {
                messages.append(message)
            } else {
                return nil
            }
        }
    }

}

struct V2APIPrivateMessage: APIPrivateMessage {

    static let dateFormatter = Iso8601DateFormatter()

    var id: String
    var authorName: String
    var subject: String
    var message: String
    var recipientUid: String
    var lastChangeDateTime: Date
    var createdDateTime: Date
    var receievedDateTime: Date
    var readDateTime: Date?

    init?(jsonDictionary: [String : Any]) {
        let dateFormatter = V2APIPrivateMessage.dateFormatter
        guard let id = jsonDictionary["Id"] as? String,
            let authorName = jsonDictionary["AuthorName"] as? String,
            let subject = jsonDictionary["Subject"] as? String,
            let message = jsonDictionary["Message"] as? String,
            let recipientUid = jsonDictionary["RecipientUid"] as? String,
            let lastChangeDateTimeString = jsonDictionary["LastChangeDateTimeUtc"] as? String,
            let createdDateTimeString = jsonDictionary["CreatedDateTimeUtc"] as? String,
            let receievedDateTimeString = jsonDictionary["ReceivedDateTimeUtc"] as? String,
            let lastChangeDateTime = dateFormatter.date(from: lastChangeDateTimeString),
            let createdDateTime = dateFormatter.date(from: createdDateTimeString),
            let receievedDateTime = dateFormatter.date(from: receievedDateTimeString) else {
                return nil
        }

        self.id = id
        self.authorName = authorName
        self.subject = subject
        self.message = message
        self.recipientUid = recipientUid
        self.lastChangeDateTime = lastChangeDateTime
        self.createdDateTime = createdDateTime
        self.receievedDateTime = receievedDateTime

        if let readDateTimeString = jsonDictionary["ReadDateTimeUtc"] as? String,
           let readDateTime = dateFormatter.date(from: readDateTimeString) {
            self.readDateTime = readDateTime
        }
    }

}
