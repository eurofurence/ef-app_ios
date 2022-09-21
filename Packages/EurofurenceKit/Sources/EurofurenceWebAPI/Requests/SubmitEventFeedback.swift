import Foundation

extension APIRequests {
    
    public struct SubmitEventFeedback: APIRequest {
        
        private let identifier: String
        private let rating: Int
        private let additionalComments: String
        
        public init(
            identifier: String,
            rating: Int,
            additionalComments: String
        ) {
            self.identifier = identifier
            self.rating = rating
            self.additionalComments = additionalComments
        }
        
        public typealias Output = Void
        
        public func execute(with context: APIRequestExecutionContext) async throws {
            let url = context.makeURL(subpath: "EventFeedback")
            let bodyContents = SubmitFeedbackContents(EventId: identifier, Rating: rating, Message: additionalComments)
            let encoder = JSONEncoder()
            let body = try encoder.encode(bodyContents)
            let request = NetworkRequest(url: url, body: body, method: .post)
            
            try await context.network.perform(request: request)
        }
        
        private struct SubmitFeedbackContents: Encodable {
            var EventId: String
            var Rating: Int
            var Message: String
        }
        
    }
    
}
