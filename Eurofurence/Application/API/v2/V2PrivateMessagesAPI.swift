//
//  V2PrivateMessagesAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct V2PrivateMessagesAPI: PrivateMessagesAPI {

    // MARK: Properties

    var jsonSession: JSONSession
    private static var responseDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Iso8601DateFormatter.instance)
        return decoder
    }()

    // MARK: PrivateMessagesAPI

    func loadPrivateMessages(authorizationToken: String,
                             completionHandler: @escaping ([Message]?) -> Void) {
        var request = JSONRequest(url: "https://app.eurofurence.org/api/v2/Communication/PrivateMessages", body: Data())
        request.headers = ["Authorization": "Bearer \(authorizationToken)"]
        jsonSession.get(request) { data, _ in
            if let data = data, let messages = try? V2PrivateMessagesAPI.responseDecoder.decode([Response.Message].self, from: data) {
                completionHandler(messages.map({ $0.makeMessage() }))
            } else {
                completionHandler(nil)
            }
        }
    }

    func markMessageWithIdentifierAsRead(_ identifier: String, authorizationToken: String) {
        var request = JSONRequest(url: "https://app.eurofurence.org/api/v2/Communication/PrivateMessages/\(identifier)/Read",
                              body: Data())
        request.headers = ["Authorization": "Bearer \(authorizationToken)"]
        jsonSession.post(request, completionHandler: { _ in })
    }

    // MARK: Private

    private struct Response: APIPrivateMessagesResponse {

        var messages: [APIPrivateMessage]

        struct Message: APIPrivateMessage, Decodable {

            var id: String
            var authorName: String
            var subject: String
            var message: String
            var recipientUid: String
            var lastChangeDateTime: Date
            var createdDateTime: Date
            var receivedDateTime: Date
            var readDateTime: Date?

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                id = try container.decode(String.self, forKey: .id)
                authorName = try container.decode(String.self, forKey: .authorName)
                subject = try container.decode(String.self, forKey: .subject)
                message = try container.decode(String.self, forKey: .message)
                recipientUid = try container.decode(String.self, forKey: .recipientUid)
                lastChangeDateTime = try container.decode(Date.self, forKey: .lastChangeDateTime)
                createdDateTime = try container.decode(Date.self, forKey: .createdDateTime)
                receivedDateTime = try container.decode(Date.self, forKey: .receivedDateTime)

                if let readTime = try? container.decodeIfPresent(Date.self, forKey: .readDateTime) {
                    readDateTime = readTime
                }
            }

            private enum CodingKeys: String, CodingKey {
                case id = "Id"
                case authorName = "AuthorName"
                case subject = "Subject"
                case message = "Message"
                case recipientUid = "RecipientUid"
                case lastChangeDateTime = "LastChangeDateTimeUtc"
                case createdDateTime = "CreatedDateTimeUtc"
                case receivedDateTime = "ReceivedDateTimeUtc"
                case readDateTime = "ReadDateTimeUtc"
            }

            func makeMessage() -> Eurofurence.Message {
                return Eurofurence.Message(identifier: id,
                                           authorName: authorName,
                                           receivedDateTime: receivedDateTime,
                                           subject: subject,
                                           contents: message,
                                           isRead: readDateTime != nil)
            }

        }

    }

}
