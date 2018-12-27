//
//  V2API.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public struct V2API: ImageAPI, LoginAPI, PrivateMessagesAPI {

    // MARK: Properties

    private let jsonSession: JSONSession
    private let apiUrl: String
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    // MARK: Initialization

    public init(jsonSession: JSONSession, apiUrl: V2ApiUrlProviding) {
        self.jsonSession = jsonSession
        self.apiUrl = apiUrl.url

        // TODO: Investigate why system ios8601 formatter fails to parse our dates
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Iso8601DateFormatter())

        encoder = JSONEncoder()
    }

    // MARK: LoginAPI

    public func performLogin(request: LoginRequest, completionHandler: @escaping (LoginResponse?) -> Void) {
        let url = apiUrl + "Tokens/RegSys"
        let request: Request.Login = Request.Login(RegNo: request.regNo, Username: request.username, Password: request.password)
        let jsonData = try! encoder.encode(request)
        let jsonRequest = JSONRequest(url: url, body: jsonData)
        
        jsonSession.post(jsonRequest) { (data, _) in
            if let data = data, let response = try? self.decoder.decode(Response.Login.self, from: data) {
                completionHandler(response.makeDomainLoginResponse())
            } else {
                completionHandler(nil)
            }
        }
    }
    
    // MARK: ImageAPI
    
    public func fetchImage(identifier: String, completionHandler: @escaping (Data?) -> Void) {
        let url = apiUrl + "Images/\(identifier)/Content"
        let request = JSONRequest(url: url)
        
        jsonSession.get(request) { (data, _) in
            completionHandler(data)
        }
    }
    
    // MARK: PrivateMessagesAPI
    
    public func loadPrivateMessages(authorizationToken: String,
                                    completionHandler: @escaping ([Message]?) -> Void) {
        let url = apiUrl + "Communication/PrivateMessages"
        var request = JSONRequest(url: url)
        request.headers = ["Authorization": "Bearer \(authorizationToken)"]
        
        jsonSession.get(request) { (data, _) in
            var messages: [Message]?
            defer { completionHandler(messages) }
            
            guard let data = data else { return }
            
            if let jsonMessages = try? self.decoder.decode([Response.Message].self, from: data) {
                messages = jsonMessages.map({ $0.makeAppDomainMessage() })
            }
        }
    }
    
    public func markMessageWithIdentifierAsRead(_ identifier: String, authorizationToken: String) {
        let url = apiUrl + "Communication/PrivateMessages/\(identifier)/Read"
        let messageContentsToSupportSwagger = "true".data(using: .utf8)!
        var request = JSONRequest(url: url, body: messageContentsToSupportSwagger)
        request.headers = ["Authorization": "Bearer \(authorizationToken)"]
        
        jsonSession.post(request, completionHandler: { (_, _)  in })
    }

    // MARK: Private
    
    private struct Request {
        
        struct Login: Encodable {
            var RegNo: Int
            var Username: String
            var Password: String
        }
        
    }
    
    private struct Response {
        
        struct Login: Decodable {
            var Uid: String
            var Username: String
            var Token: String
            var TokenValidUntil: Date
            
            func makeDomainLoginResponse() -> LoginResponse {
                return LoginResponse(userIdentifier: Uid,
                                     username: Username,
                                     token: Token,
                                     tokenValidUntil: TokenValidUntil)
            }
        }
        
        struct Message: Decodable {
            
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
            
            func makeAppDomainMessage() -> EurofurenceModel.Message {
                return EurofurenceModel.Message(identifier: id,
                                                authorName: authorName,
                                                receivedDateTime: receivedDateTime,
                                                subject: subject,
                                                contents: message,
                                                isRead: readDateTime != nil)
            }
            
        }
        
    }

}
