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

    private var jsonSession: JSONSession
    private var decoder: JSONDecoder

    // MARK: Initialization

    init(jsonSession: JSONSession) {
        self.jsonSession = jsonSession

        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Iso8601DateFormatter.instance)
    }

    // MARK: PrivateMessagesAPI

    func loadPrivateMessages(authorizationToken: String,
                             completionHandler: @escaping ([Message]?) -> Void) {
        var request = JSONRequest(url: "https://app.eurofurence.org/api/v2/Communication/PrivateMessages", body: Data())
        request.headers = ["Authorization": "Bearer \(authorizationToken)"]
        jsonSession.get(request) { (data, _) in
            var messages: [Message]?
            defer { completionHandler(messages) }

            guard let data = data else { return }

            if let jsonMessages = try? self.decoder.decode([JSONMessage].self, from: data) {
                messages = jsonMessages.map({ $0.makeAppDomainMessage() })
            }
        }
    }

    func markMessageWithIdentifierAsRead(_ identifier: String, authorizationToken: String) {
        let url = "https://app.eurofurence.org/api/v2/Communication/PrivateMessages/\(identifier)/Read"
        let messageContentsToSupportSwagger = "true".data(using: .utf8)!
        var request = JSONRequest(url: url, body: messageContentsToSupportSwagger)
        request.headers = ["Authorization": "Bearer \(authorizationToken)"]

        jsonSession.post(request, completionHandler: { (_) in })
    }

    // MARK: Private

    private struct JSONMessage: Decodable {

        var id: String
        var authorName: String
        var subject: String
        var message: String
        var receivedDateTime: Date
        var readDateTime: Date?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            authorName = try container.decode(String.self, forKey: .authorName)
            subject = try container.decode(String.self, forKey: .subject)
            message = try container.decode(String.self, forKey: .message)
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
            case receivedDateTime = "ReceivedDateTimeUtc"
            case readDateTime = "ReadDateTimeUtc"
        }

        func makeAppDomainMessage() -> Eurofurence.Message {
            return Eurofurence.Message(identifier: id,
                                       authorName: authorName,
                                       receivedDateTime: receivedDateTime,
                                       subject: subject,
                                       contents: message,
                                       isRead: readDateTime != nil)
        }

    }

}
