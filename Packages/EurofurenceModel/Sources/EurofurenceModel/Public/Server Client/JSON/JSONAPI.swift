import Foundation

// swiftlint:disable nesting
public struct JSONAPI: API {

    // MARK: Properties

    private let jsonSession: JSONSession
    private let apiUrl: String
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    // MARK: Initialization

    public init(jsonSession: JSONSession, apiUrl: APIURLProviding) {
        self.jsonSession = jsonSession
        self.apiUrl = {
            var url = apiUrl.url
            if url.hasSuffix("/") {
                url.removeLast()
            }
            
            return url
        }()

        // TODO: Investigate why system ios8601 formatter fails to parse our dates
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Iso8601DateFormatter())

        encoder = JSONEncoder()
    }

    // MARK: LoginAPI

    public func performLogin(request: APIRequests.LoginRequest, completionHandler: @escaping (LoginResponse?) -> Void) {
        let url = urlStringByAppending(pathComponent: "Tokens/RegSys")
        let request = Request.Login(RegNo: request.regNo, Username: request.username, Password: request.password)
        guard let jsonData = try? encoder.encode(request) else { return }
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

    public func fetchImage(identifier: String, contentHashSha1: String, completionHandler: @escaping (Data?) -> Void) {
        let url = urlStringByAppending(pathComponent: "Images/\(identifier)/Content/with-hash:\(contentHashSha1)")
        let request = JSONRequest(url: url)

        jsonSession.get(request) { (data, _) in
            completionHandler(data)
        }
    }

    // MARK: PrivateMessagesAPI
    
    public func loadPrivateMessages(
        authorizationToken: String,
        completionHandler: @escaping ([MessageCharacteristics]?) -> Void
    ) {
        let url = urlStringByAppending(pathComponent: "Communication/PrivateMessages")
        var request = JSONRequest(url: url)
        request.headers = ["Authorization": "Bearer \(authorizationToken)"]
        
        jsonSession.get(request) { (data, _) in
            var messages: [MessageCharacteristics]?
            defer { completionHandler(messages) }

            guard let data = data else { return }

            if let jsonMessages = try? self.decoder.decode([Response.Message].self, from: data) {
                messages = jsonMessages.map({ $0.makeAppDomainMessage() })
            }
        }
    }

    public func markMessageWithIdentifierAsRead(_ identifier: String, authorizationToken: String) {
        let url = urlStringByAppending(pathComponent: "Communication/PrivateMessages/\(identifier)/Read")
        guard let messageContentsToSupportSwagger = "true".data(using: .utf8) else { fatalError() }
        
        var request = JSONRequest(url: url, body: messageContentsToSupportSwagger)
        request.headers = ["Authorization": "Bearer \(authorizationToken)"]

        jsonSession.post(request, completionHandler: { (_, _)  in })
    }

    // MARK: SyncAPI

    public func fetchLatestData(lastSyncTime: Date?, completionHandler: @escaping (ModelCharacteristics?) -> Void) {
        let sinceParameterPathComponent: String = {
            if let lastSyncTime = lastSyncTime {
                let formattedTime = Iso8601DateFormatter.instance.string(from: lastSyncTime)
                return "?since=\(formattedTime)"
            } else {
                return ""
            }
        }()

        let url = urlStringByAppending(pathComponent: "Sync\(sinceParameterPathComponent)")
        let request = JSONRequest(url: url, body: Data())

        jsonSession.get(request) { (data, _) in
            var response: ModelCharacteristics?
            defer { completionHandler(response) }

            if let data = data {
                do {
                    let decodedResponse = try self.decoder.decode(JSONSyncResponse.self, from: data)
                    response = decodedResponse.asAPIResponse()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    public func submitEventFeedback(_ request: EventFeedbackRequest, completionHandler: @escaping (Bool) -> Void) {
        let feedback = Request.EventFeedback(EventId: request.id, Rating: request.starRating, Message: request.feedback)
        guard let data = try? encoder.encode(feedback) else { return }
        
        let url = urlStringByAppending(pathComponent: "EventFeedback")
        let jsonRequest = JSONRequest(url: url, body: data)
        jsonSession.post(jsonRequest) { (_, error) in
            let successful = error == nil
            completionHandler(successful)
        }
    }

    // MARK: Private
    
    private func urlStringByAppending(pathComponent: String) -> String {
        return "\(apiUrl)/\(pathComponent)"
    }

    private struct Request {

        struct Login: Encodable {
            var RegNo: Int
            var Username: String
            var Password: String
        }
        
        struct EventFeedback: Encodable {
            var EventId: String
            var Rating: Int
            var Message: String
        }

    }

    private struct Response {

        struct Login: Decodable {
            var Uid: String
            var Username: String
            var Token: String
            var TokenValidUntil: Date

            func makeDomainLoginResponse() -> LoginResponse {
                return LoginResponse(
                    userIdentifier: Uid,
                    username: Username,
                    token: Token,
                    tokenValidUntil: TokenValidUntil
                )
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

                if let readTime = ((try? container.decodeIfPresent(Date.self, forKey: .readDateTime)) as Date??) {
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
            
            func makeAppDomainMessage() -> EurofurenceModel.MessageCharacteristics {
                return MessageCharacteristics(
                    identifier: id,
                    authorName: authorName,
                    receivedDateTime: receivedDateTime,
                    subject: subject,
                    contents: message,
                    isRead: readDateTime != nil
                )
            }

        }

    }

}
